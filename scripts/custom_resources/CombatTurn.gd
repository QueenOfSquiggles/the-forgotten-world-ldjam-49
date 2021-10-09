extends Resource
class_name CombatTurn

export (String) var timeline_name : String = ""
export (float) var post_dialogue_pause := 0.5
export (Resource) var attack : Resource

func _ready() -> void:
	assert(attack is AttackPattern, "Resource type of 'attack' must be AttackPattern")

func do_turn(enemy : Node2D):
	if not enemy:
		yield(GameHelper.create_timer(0.01), "timeout")
		return

	if not timeline_name.empty():
		print("starting dialogue %s" % timeline_name)
		var dialogue = Dialogic.start(timeline_name)
		enemy.add_child(dialogue)
		yield(dialogue, "timeline_end")

	yield(GameHelper.create_timer(post_dialogue_pause), "timeout") # give a brief pause after dialogue for player to orient themselves

	print("doing attack: %s" % attack.resource_name)
	yield(attack.do_turn(enemy), "completed")

func turn_params_met() -> bool:
	return true
