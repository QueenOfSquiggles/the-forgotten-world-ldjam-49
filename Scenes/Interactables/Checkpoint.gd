extends Interactable


func interact():
	yield(.interact(), "completed")
	GameHelper.player_health = 10
	GameHelper.save_data()
	# we should only have checkpoints in levels and all levels should have this function
	get_tree().current_scene.save_level()
