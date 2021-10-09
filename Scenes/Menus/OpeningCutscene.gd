extends Node2D

onready var anim := $AnimatedSprite

func _ready() -> void:
	anim.play()


func _on_AnimatedSprite_animation_finished() -> void:
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
