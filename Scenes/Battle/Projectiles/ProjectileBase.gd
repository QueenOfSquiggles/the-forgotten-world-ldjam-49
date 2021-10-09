extends Area2D
class_name Projectile

var speed := 100.0

func _process(delta: float) -> void:
	var dir := _get_dir_vec()
	self.position += dir.normalized() * delta * speed


func _get_dir_vec() -> Vector2:
	var result = Vector2()
	result.x = cos(rotation)
	result.y = sin(rotation)
	return result


func _on_ProjectileBase_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		GameHelper.hurt_player(1)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
