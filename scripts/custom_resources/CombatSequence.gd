extends Resource
class_name CombatSequence

enum LoopStyle {
	FullLoop, RepeatEnd, RestartFromX
}


export (LoopStyle) var Loop := LoopStyle.FullLoop
export (int) var X := 0
export (Array, Resource) var turns : Array


var index := 0


func _ready() -> void:
	for t in turns:
		assert(t is CombatTurn, "CombatSequence only takes CombatTurn's as turn values")
	assert(X >= 0 and X < turns.size(), "X must be within the range of the array indices")

func do_turn(enemy : Node2D):
	if not enemy:
		yield(GameHelper.create_timer(0.01), "timeout")
		return
	var t := turns[index] as CombatTurn
	print("Doing turn : %s " % t.resource_name)
	yield(t.do_turn(enemy), "completed")

	if t.turn_params_met():
		print("turn params met, next turn")
		index += 1
	if index >= turns.size():
		overflow_condition()
		print("Overflow reached. index now : %s" % index)

func overflow_condition():
	match Loop:
		LoopStyle.FullLoop:
			index=0
		LoopStyle.RepeatEnd:
			index = turns.size()-1
		LoopStyle.RestartFromX:
			index = X
