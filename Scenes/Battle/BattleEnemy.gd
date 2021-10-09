extends Node2D
class_name Battler

export (int) var MaxHP := 2
export (float) var MercyThreshold := 1.0
export (NodePath) var WorldSpaceRoot : NodePath
export (Resource) var combat_sequence : Resource
export (Array, Resource) var combat_actions : Array = []
var current_hp = MaxHP
var sequence : CombatSequence

var mercy_amnt := 0.0

var is_attacking := false

func _ready() -> void:
	current_hp = MaxHP
	sequence = combat_sequence as CombatSequence
	assert(sequence, "Battler requires a valid CombatSequence")

func do_turn():
	print("[",self.name,"] Turn")
	yield(perform_attack(), "completed")

func perform_attack():
	is_attacking = true
	yield(sequence.do_turn(self), "completed")
	is_attacking = false

func damage(amnt : int):
	current_hp -= amnt
	if current_hp < 0:
		# dead
		print("%s is now dead" % self.name)
		call_deferred("queue_free")

func do_action():
	pass

func try_spare()->void:
	if mercy_amnt >= MercyThreshold:
		print("%s was spared" % self.name)
		call_deferred("queue_free")

