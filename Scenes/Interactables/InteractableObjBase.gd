extends StaticBody2D

class_name Interactable

export (String) var CustomTimelineOverride := ""
export (String, MULTILINE) var InteractionText := ""

const InteractionDialogueModular := "object_interaction"
const SwapKey := "interact_temp_text"
const InteractCooldownBuffer = 0.1

# optionally generate the dialogue in code entirely. Might be better?

var start_child_count := 0
var busy := false
signal interaction_complete

func _ready() -> void:
	start_child_count = get_child_count() # load dynamically in case of future situations
	# no magic numb


func interact():
	if _has_dialoge():
		yield(get_tree().create_timer(0.01), "timeout")
		return # abort so we don't stack
	busy = true
	var dialogue = _generate_dialogue()
	add_child(dialogue)
	yield(dialogue, "timeline_end")
	emit_signal("interaction_complete")
	$Timer.start(InteractCooldownBuffer)


func _generate_dialogue():
	if !CustomTimelineOverride.empty():
		return Dialogic.start(CustomTimelineOverride, false)
	var d = Dialogic.start('', false)
	var dict := {"events":[]}

	var strArr = InteractionText.split("<br>")
	for line in strArr:
		var lineDict = _get_line_event(line)
		dict.events.append(lineDict)
	dict.events.append({ # close dialog transition
			"event_id": "dialogic_022",
			"transition_duration": 0.1
		});
	d.set_dialog_script(dict)
	return d

func _get_line_event(text : String) -> Dictionary:
	return { 'event_id':'dialogic_001', "text": text}


func _on_Timer_timeout() -> void:
	busy = false

func _has_dialoge() -> bool:
	if get_child_count() > start_child_count:
		# more children than before!
		return true
	return false
