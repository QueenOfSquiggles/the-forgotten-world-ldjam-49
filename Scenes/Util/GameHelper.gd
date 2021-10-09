extends Node

var player : Node2D

var player_health := 10

var save_data : Dictionary = {
	player_position = Vector2.ZERO,
	level_path = "",
	player_health = 10,
}

var temp_save = null
var portalID = null

const SAVE_DATA_PATH := "user://savegame.save"

signal on_player_health_change

func _ready() -> void:
	reload_player_object()

func reload_player_object():
	print("Reloading player object")
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() > 0:
		player = nodes[0]
		print("Found player object : %s" % player.name)
	else:
		player = null
		print("No player found in scene. This might be a problem!")



func get_player() -> Node2D:
	if not player:
		reload_player_object()
	assert(player != null, "Failed to locate player object!")
	return player

func save_data() -> void:
	print("Start save data!")
	var p = get_player()
	print("Loaded player")
	_update_save_data_dict(p)
	print("Updated save data dictionary")
	var save_file := File.new()
	save_file.open(SAVE_DATA_PATH, File.WRITE)
	save_file.store_var(save_data, true)
	print("Saved data to %s" % str(save_file.get_path_absolute()))
	save_file.close()

func load_data() -> bool:
	var save_file := File.new()
	if not save_file.file_exists(SAVE_DATA_PATH):
		return false
	save_file.open(SAVE_DATA_PATH, File.READ)
	var data_var = save_file.get_var(true)
	print("Loaded data : %s " % str(data_var))
	save_data = data_var
	save_file.close()
	print("Loaded data : %s" % save_data)
	player_health = save_data.player_health
	return true

func set_temp_save() -> void:
	temp_save = {}
	temp_save.player_position = get_player().global_position
	temp_save.level_path = get_tree().current_scene.filename # should give us the filepath to the TSCN
	print("Set up temp save : %s" % temp_save)

func load_from_temp_save() -> void:
	var path = save_data.level_path
	if temp_save:
		path = temp_save.level_path
	else:
		print("No temporary save found. Using regular save data as a fallback")
	get_tree().change_scene(path)

func apply_loaded_data() -> void:
	reload_player_object()

	var data := save_data
	if temp_save:
		data = (temp_save as Dictionary).duplicate(true)
		temp_save = null
	print("Applying loaded data : %s" % data)
	if not get_tree().current_scene.filename == data.level_path:
		return
	var p := get_player() # do this after because the player object has to be in the level scene
	if not p or p == null or not is_instance_valid(p) or data.player_position == Vector2.ZERO:
		return
	if not try_load_portal_pos(p):
		p.position = data.player_position
	print("Set player position to: %s" % p.position)

func try_load_portal_pos(player : Node2D) -> bool:
	if portalID == null:
		# did not load from a portal
		return false
	var agg := get_tree().get_nodes_in_group("portal_output")
	for a in agg:
		var n = a as Node
		if n.has_method("get_id"):
			var id = n.get_id()
			if id == portalID:
				var pos := n as Position2D
				if pos:
					player.global_position = pos.global_position
					return true
	return false

func _update_save_data_dict(player : Node2D) -> void:
	save_data.player_position = player.global_position
	save_data.player_health = player_health
	save_data.level_path = get_tree().current_scene.filename # should give us the filepath to the TSCN
	print(save_data)

func get_checkpoint_level() -> String:
	return save_data.level_path

const save_ext := ".save"

func delete_save():
	var save_dir := Directory.new()
	save_dir.open("user://")
	save_dir.list_dir_begin()
	while true:
		var file = save_dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file.ends_with(save_ext):
				save_dir.remove(file)
				print("deleting file [%s]" % file)
	save_dir.list_dir_end()

func load_player_from_portal(portal : String) -> void:
	portalID = portal

func hurt_player(dmg : int) -> void:
	player_health -= dmg
	emit_signal("on_player_health_change")
	if player_health <= 0:
		print("Player has died!")
		# restart from last checkpoint
		# delete temp save
		temp_save = null
		# change scene
		get_tree().call_deferred("change_scene", "res://Scenes/Util/LoadCheckpoint.tscn")


func create_timer(seconds : float) -> SceneTreeTimer:
	return get_tree().create_timer(seconds)
