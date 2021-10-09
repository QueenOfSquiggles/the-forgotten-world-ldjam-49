extends Control


func _ready() -> void:
	activate()

func activate():
	var c := get_parent() as Control
	assert(c) # we failed to have a control parent. FIX THIS
	c.grab_focus()
