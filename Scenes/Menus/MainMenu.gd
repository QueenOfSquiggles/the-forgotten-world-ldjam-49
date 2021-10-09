extends Control

const CheckpointLoaderScene := "res://Scenes/Util/LoadCheckpoint.tscn"
const OptionsMenuScene := "res://Scenes/Menus/OptionsMenu.tscn"
const CreditsMenuScene := "res://Scenes/Menus/CreditsMenu.tscn"

const URL_Twitter := "https://twitter.com/OfSquiggles"
const URL_Ludum := "https://ldjam.com/events/ludum-dare/49/$258681"
const URL_Itch := "https://queenofsquiggles.itch.io/ld49-game"


func _on_BtnPlay_pressed() -> void:
	# load save data and play
	get_tree().change_scene(CheckpointLoaderScene)


func _on_BtnOptions_pressed() -> void:
	# load options menu
	get_tree().change_scene(OptionsMenuScene)


func _on_BtnCredits_pressed() -> void:
	# load credits screen
	get_tree().change_scene(CreditsMenuScene)


func _on_BtnQuit_pressed() -> void:
	get_tree().quit()

func _on_BtnTwitter_pressed() -> void:
	_open_in_browser(URL_Twitter)


func _on_BtnLudum_pressed() -> void:
	_open_in_browser(URL_Ludum)


func _on_BtnItch_pressed() -> void:
	_open_in_browser(URL_Itch)

func _open_in_browser(url : String) -> void:
	OS.shell_open(url)

