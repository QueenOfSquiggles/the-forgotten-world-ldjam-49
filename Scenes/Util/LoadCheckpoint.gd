extends Node

export (PackedScene) var StartLevel : PackedScene

func _ready() -> void:
	_load_scene()

func _load_scene():
	var path = StartLevel.resource_path
	if GameHelper.load_data():
		# if we successfully loaded data
		path = GameHelper.get_checkpoint_level()
		print("Loaded save data. Opening level %s" % path)
	else:
		print("No save data. Starting from scratch!")
	# load whatever made it to the path
	print("loading scene %s" % path)
	get_tree().change_scene(path)

