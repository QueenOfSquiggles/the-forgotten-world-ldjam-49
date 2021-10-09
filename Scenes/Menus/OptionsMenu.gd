extends Control

const MainMenuScenePath := "res://Scenes/Menus/MainMenu.tscn"

onready var popup := $ConfirmationDialog
onready var info_pop := $AcceptDialog

func _on_BtnReturn_pressed() -> void:
	get_tree().change_scene(MainMenuScenePath)


func _on_BtnDeleteSaveData_pressed() -> void:
	popup.popup_centered()
	popup.connect("confirmed", GameHelper, "delete_save")
	popup.connect("confirmed", info_pop, "popup_centered")
