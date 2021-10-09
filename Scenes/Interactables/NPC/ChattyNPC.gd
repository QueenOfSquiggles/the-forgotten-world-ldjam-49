extends "res://Scenes/Interactables/InteractableObjBase.gd"

export (String) var InternalCharPath := "character-1633182273.json"

func _get_line_event(text : String) -> Dictionary:
	return {'character': InternalCharPath, 'event_id':'dialogic_001', "text": text}
