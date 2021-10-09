extends Node2D

var states : Array = []

func do_turn():
	for c in get_children():
		# call each child node to do their turn
		states.append(c.do_turn())
	for hold in states:
		yield(hold, "completed")
	states.clear()
