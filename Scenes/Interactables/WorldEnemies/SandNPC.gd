extends Interactable

export (String, FILE) var BattleScenePath := "res://Scenes/Battle/specific_battles/BattleS_and_P.tscn"


func interact():
	if _has_dialoge():
		timer.start(0.01)
		yield(timer, "timeout")
		return # abort so we don't stack
	busy = true
	var dialogue = _generate_dialogue()
	add_child(dialogue)
	yield(dialogue, "timeline_end")

	print("%s is attacking!" % self.name)
	GameHelper.set_temp_save()
	# call deferred so we have time to get player data saved
	get_tree().current_scene.delete(self)
	get_tree().call_deferred("change_scene", BattleScenePath)

	emit_signal("interaction_complete")
	$Timer.start(InteractCooldownBuffer)
