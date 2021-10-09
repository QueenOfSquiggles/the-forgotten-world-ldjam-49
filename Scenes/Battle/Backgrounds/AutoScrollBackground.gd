extends ParallaxBackground

export (Vector2) var auto_scroll_direction := Vector2.UP
export (float) var auto_scroll_speed := 10.0

func _process(delta: float) -> void:
	self.scroll_offset += auto_scroll_direction * auto_scroll_speed * delta
