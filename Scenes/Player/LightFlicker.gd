extends Light2D

export (float) var FlickerSpeed := 1.0
export (float) var FlickerRange := 0.5

var start_scale : float
var time := 0.0

func _ready() -> void:
	start_scale = self.texture_scale

func _process(delta: float) -> void:
	time += delta
	self.texture_scale = start_scale + sin(time * FlickerSpeed) * FlickerRange
