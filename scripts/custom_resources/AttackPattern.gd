extends Resource
class_name AttackPattern

export (PackedScene) var ProjectileScene : PackedScene = preload("res://Scenes/Battle/Projectiles/ProjectileBase.tscn")

func do_turn(enemy : Node2D):
	if not enemy:
		yield(GameHelper.create_timer(0.01), "timeout")
		return
	yield(enemy.get_tree().create_timer(0.5), "timeout")
