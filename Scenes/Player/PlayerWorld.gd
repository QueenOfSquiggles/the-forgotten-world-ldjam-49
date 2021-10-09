extends KinematicBody2D

const Speed := 100.0

onready var Interactables := $InteractDetector
onready var Anim := $PlayerWorld
onready var InteractNotifier := $InteractNotifier
onready var InteractSFX := $InteractSFX

var previous_look_dir := Vector2.DOWN
var is_interacting := false

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


func _process(delta: float) -> void:
	var interact := _interact_check()
	InteractNotifier.visible = (interact != null)
	if interact && Input.is_action_pressed("dialogue_proceed"):
		#do interact checks
		if interact.busy:
			return
		#print("start")
		is_interacting = true
		_update_anim(previous_look_dir, false)
		InteractSFX.play()
		interact.interact()
		yield(interact, "interaction_complete")
		is_interacting = false


func _interact_check() -> Interactable:
	var bodies = $InteractDetector.get_overlapping_bodies()
	for b in bodies:
		var n = b as Node2D
		if n is Interactable:
			return n
	return null

func _physics_process(delta: float) -> void:
	if not is_interacting:
		var input := _get_input()
		var nLook = _get_look_dir(input)
		_update_anim(nLook, input != Vector2.ZERO)
		previous_look_dir = nLook
		move_and_slide(input.normalized() * Speed)

func _get_look_dir(vec : Vector2) -> Vector2:
	var temp = Vector2(sign(vec.x), sign(vec.y))
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

func _get_input() -> Vector2:
	var d := Vector2()
	d.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	d.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return d
