extends Node2D

class_name CombatQueue

var active : Node2D
var index := 0

signal on_round_completed

onready var player_proxy := $PlayerTurnProxy

func _ready() -> void:
	GameHelper.reload_player_object()
	assert(get_child_count() > 0)
	active = get_child(0)
	do_round()

func do_round():
	if get_child_count() > 1:
		for _i in range(get_child_count()):
			if get_child_count() <= 1:
				# if we spare the one and only enemy, don't prompt for actions again
				break
			yield(do_turn(), "completed")
			if (GameHelper.player_health <= 0):
				get_tree().change_scene("res://Scenes/Util/LoadCheckpoint.tscn")

	else:
		# combat over
		GameHelper.load_from_temp_save()
		return
	do_round()


func check_if_valid() -> bool:
	for i in range(get_child_count()):
		if get_child(i) is Battler:
			return true
	return false

func do_turn():
	yield(active.do_turn(), "completed")
	var idx : int = index + 1
	if is_instance_valid(active):
		idx = active.get_index() + 1

	index = idx

	if idx >= get_child_count():
		idx = 0
	active = get_child(idx)
	if idx == 0:
		on_round_complete()

func on_round_complete():
	emit_signal("on_round_completed")
	# check if all enemies have died?
	#if not complete, start another round

func get_actions() -> Array:
	var actions := []
	for i in range(get_child_count()):
		var b = get_child(i) as Battler
		if b:
			var agg : Array = b.combat_actions
			if not agg.empty():
				actions.append_array(agg)
	return actions

func attack_enemies(amnt : int) -> void:
	for i in range(get_child_count()):
		var b = get_child(i) as Battler
		if b:
			b.damage(amnt)
func spare_enemies() -> void:
	for i in range(get_child_count()):
		var b = get_child(i) as Battler
		if b:
			b.try_spare()

func do_mercy_action(action : MercyAction):
	for i in range(get_child_count()):
		var b = get_child(i) as Battler
		if b:
			var agg : Array = b.combat_actions
			if agg.has(action):
				b.mercy_amnt += action.mercy_amount
func can_spare() -> bool:
	for i in range(get_child_count()):
		var b = get_child(i) as Battler
		if b:
			if b.mercy_amnt >= b.MercyThreshold:
				return true
	return false
