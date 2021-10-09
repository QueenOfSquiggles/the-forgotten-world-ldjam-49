extends KinematicBody2D


export (String, FILE) var BattleScenePath := ""

const Speed := 50.0

onready var Anim := $AnimatedSprite

var previous_look_dir := Vector2.DOWN

const AnimNames := {
	# dictionary of animation tags for ease of use and quick refactor
	StandUp = "Stand_up",
	StandDown = "Stand_down",
	StandRight = "Stand_right",
	StandLeft = "Stand_left",
	WalkUp = "Walk_up",
	WalkDown = "Walk_down",
	WalkRight = "Walk_right",
	WalkLeft = "Walk_left"
}

func _physics_process(delta: float) -> void:
	var input := _get_input()
	var nLook = _get_look_dir(input)
	_update_anim(nLook, input != Vector2.ZERO)
	previous_look_dir = nLook
	move_and_slide(input.normalized() * Speed)

func _get_look_dir(vec : Vector2) -> Vector2:
	var temp = Vector2(sign(vec.x), sign(vec.y))
	if abs(vec.x) > abs(vec.y):
		temp.y = 0
	if abs(vec.y) > abs(vec.x):
		temp.x = 0
	return previous_look_dir if temp == Vector2.ZERO else temp

func _update_anim(next : Vector2, moving : bool) -> void:
	match next:
		Vector2.UP:
			if moving:
				if not Anim.animation == AnimNames.WalkUp:
					Anim.play(AnimNames.WalkUp)
					return
			else:
				if not Anim.animation == AnimNames.StandUp:
					Anim.play(AnimNames.StandUp)
					return
		Vector2.LEFT:
			if moving:
				if not Anim.animation == AnimNames.WalkLeft:
					Anim.play(AnimNames.WalkLeft)
					return
			else:
				if not Anim.animation == AnimNames.StandLeft:
					Anim.play(AnimNames.StandLeft)
					return
		Vector2.RIGHT:
			if moving:
				if not Anim.animation == AnimNames.WalkRight:
					Anim.play(AnimNames.WalkRight)
					return
			else:
				if not Anim.animation == AnimNames.StandRight:
					Anim.play(AnimNames.StandRight)
					return
		Vector2.DOWN:
			if moving:
				if not Anim.animation == AnimNames.WalkDown:
					Anim.play(AnimNames.WalkDown)
					return
			else:
				if not Anim.animation == AnimNames.StandDown:
					Anim.play(AnimNames.StandDown)
					return
		_:
			print("failed to find proper anim direction for %s with dir : %s" % [self.name, next])

func _get_input() -> Vector2:
	var delta := GameHelper.get_player().global_position - self.global_position
	delta = delta.normalized()
	return delta


func _on_battle_detector_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("%s is attacking!" % self.name)
		GameHelper.set_temp_save()
		# call deferred so we have time to get player data saved
		get_tree().current_scene.delete(self)
		get_tree().call_deferred("change_scene", BattleScenePath)
