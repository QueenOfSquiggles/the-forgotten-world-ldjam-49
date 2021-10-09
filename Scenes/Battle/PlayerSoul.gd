extends KinematicBody2D

class_name PlayerSoul

const Speed := 100.0
var locked := true

var start_pos : Vector2

func _ready() -> void:
	start_pos = position

func reset_pos():
	position = start_pos

func _physics_process(_delta: float) -> void:
	if locked:
		return
	var input := _get_input()
	var _res = move_and_slide(input.normalized() * Speed)

func _get_input() -> Vector2:
	var d := Vector2()
	d.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	d.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return d

