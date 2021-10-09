extends Node2D

const MainMenuScene := "res://Scenes/Menus/MainMenu.tscn"

var persistent_objs := []

func _ready() -> void:
	#yield($LevelFinishedLoading, "ready")
	GameHelper.apply_loaded_data()
	_load_object_aggregate()
	_load_persistence()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		print("Going to main menu")
		GameHelper.set_temp_save()
		get_tree().change_scene(MainMenuScene)

func _load_object_aggregate():
	persistent_objs.clear()
	var agg := get_tree().get_nodes_in_group("persist")
	print("Found %s persistent objects in level %s" % [agg.size(), self.filename])
	for c in agg:
		var n := c as Node2D
		if not n:
			print("There shouldn't be strange nodes in the 'persist' group!")
			continue
		if n.is_in_group("persist"):
			persistent_objs.append(n.name)

func save_level():
	_save_persistence()

func delete(node : Node2D):
	print("delete called from %s" % node.name)
	if node.is_in_group("persist"):
		var name := node.name
		print("%s is in the persist group" % name)
		if persistent_objs.has(name):
			print("%s is in the persistent object array" % name)

			print("Erasing %s from persistent objects" % name)
			persistent_objs.erase(name)
			print("Value [%s] should be -1" % persistent_objs.find(name))
		else:
			print ("%s was not found in array: %s]" % [node.name, persistent_objs])
	#print("persistent objects array is now : [%s]" % persistent_objs)
	node.queue_free()
	save_level()

func _save_persistence():
	var save_dict := {}
	print("Attempting to save %s persistent objects" % persistent_objs.size())
	for o in persistent_objs:
		var node = find_node(o)
		if is_instance_valid(node):
			print("Saving data for [%s] -> {%s}" % [o, node])
			save_dict[o] = true
	if save_dict.empty():
		# all persistent objects are deleted
		save_dict["_state"] = "valid state, all persistence deleted"
	_save_file(save_dict)

func _load_persistence():
	var saved := _load_file()
	if saved.empty():
		print("no persistent data to load. Saving initial data")
		save_level()
		return
	for name in persistent_objs:
		var node := find_node(name) # get child node of name 'name'
		if is_instance_valid(node) and not saved.has(name):
			print("loading data : deleting child [%s]->{%s}" % [name, node])
			node.queue_free()
		else:
			print("%s was loaded as it was included in the save data [%s]" % [name, saved[name]])


func _save_file(data : Dictionary) -> void:
	var file = File.new()
	file.open(_get_save_file_path(), File.WRITE)
	file.store_var(data, true)
	print("Storing data in file %s. Data : %s" % [_get_save_file_path(), data])
	file.close()

func _load_file() -> Dictionary:
	var file = File.new()
	if not file.file_exists(_get_save_file_path()):
		print("No level save data to read")
		return {}
	file.open(_get_save_file_path(), File.READ)
	var dict = file.get_var(true)
	file.close()
	if dict is Dictionary:
		print("Loaded level data : %s" % dict)
		return dict
	print("Level save data did not contain dictionary? data : %s" % dict)
	return {}


func _get_save_file_path() -> String:
	return "user://save_data_" + name + ".save"
