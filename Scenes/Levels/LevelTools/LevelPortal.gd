extends Area2D

export (String) var PortalID := ""
export (String, FILE) var PortalToScene := ""

onready var timer := $Timer


func _on_LevelPortal_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		timer.start()

func _on_LevelPortal_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		timer.stop()

func _on_Timer_timeout() -> void:
	get_tree().current_scene.save_level()
	get_tree().change_scene(PortalToScene)
	GameHelper.load_player_from_portal(PortalID)
