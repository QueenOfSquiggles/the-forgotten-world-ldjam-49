extends Node

onready var player_ui := $"../../PlayerUI"
onready var player_soul := $"../../BattleMode/PlayerSoul"

func _ready() -> void:
	player_ui.disable()
	player_soul.locked = true;
	player_soul.visible = false;

func do_turn():
	print("[",self.name,"] Starting turn")
	yield(perform_attack(), "completed")
	print("[",self.name,"] Ending turn")

func perform_attack():

	player_ui.enable()
	player_soul.visible = false
	player_soul.locked = true

	yield(player_ui.do_player_turn(), "completed")

	player_ui.disable()
	player_soul.locked = false
	player_soul.reset_pos()
	player_soul.visible = true

