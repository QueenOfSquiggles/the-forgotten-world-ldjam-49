extends Node
class_name DynamicDialogue

static func create_dialogue(origin : Node, lines : Array) -> void:
	yield(GameHelper.create_timer(0.01), "timeout")
	if lines.empty():
		return
	var dialogue = Dialogic.start('')
	var dict := {"events":[]}
	for line in lines:
		var lineDict = _get_line_event(line)
		dict.events.append(lineDict)
	dict.events.append({ # close dialog transition
		"event_id": "dialogic_022",
		"transition_duration": 0.1
	});
	dialogue.set_dialog_script(dict)
	origin.add_child(dialogue)
	yield(dialogue, "timeline_end")

static func _get_line_event(text : String) -> Dictionary:
	return { 'event_id':'dialogic_001', "text": text}
