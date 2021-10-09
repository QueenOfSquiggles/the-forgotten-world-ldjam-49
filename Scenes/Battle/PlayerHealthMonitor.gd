extends Control

export (String) var LabelText := "%s HP"

onready var label := $VBoxContainer/Label
onready var bar := $VBoxContainer/TextureProgress

func _ready() -> void:
	GameHelper.connect("on_player_health_change", self, "update_health")
	update_health()

func update_health()->void:
	var hp := GameHelper.player_health
	label.text = LabelText % str(hp)
	bar.value = hp

