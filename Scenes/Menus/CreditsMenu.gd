extends Control

const MainMenuScenePath := "res://Scenes/Menus/MainMenu.tscn"

func _on_Btn_MainMenu_pressed() -> void:
	print("Going back to main menu")
	get_tree().change_scene(MainMenuScenePath)
