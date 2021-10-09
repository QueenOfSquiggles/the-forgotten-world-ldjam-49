extends Area2D

export (String) var GroupName : String
var current_object : Node2D

func _on_InteractDetector_body_entered(body: Node) -> void:
	if body.is_in_group(GroupName):
		current_object = body

func _on_InteractDetector_body_exited(body: Node) -> void:
	if current_object == body:
		current_object = null
