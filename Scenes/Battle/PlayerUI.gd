extends Control

enum Choice {
	ATTACK, ACTION, SPARE, NONE
}

export (NodePath) var combat_queue : NodePath

onready var action_options_menu := $ActionOptions
onready var action_selector := $ActionOptions/OptionButton
onready var main_buttons := $HBoxContainer

onready var btn_spare := $HBoxContainer/BtnSpare

onready var timer := $Timer

var cur_choice = Choice.NONE
var queue : CombatQueue

func _ready() -> void:
	queue = get_node(combat_queue) as CombatQueue
	assert(queue)
	action_options_menu.visible = false

func do_player_turn():
	if not queue or not action_selector:
		yield(self, "ready")
	btn_spare.disabled = not queue.can_spare()
	while cur_choice == Choice.NONE:
		timer.start(0.1)
		yield(timer, "timeout")
	match cur_choice:
		Choice.ATTACK:
			queue.attack_enemies(1)
		Choice.ACTION:
			yield(get_action_option(), "completed")
		Choice.SPARE:
			queue.spare_enemies()
	print("Player Turn Complete!")
	timer.start(0.2)
	yield(timer, "timeout")
	cur_choice = Choice.NONE

func get_action_option():

	var actions := queue.get_actions()
	action_selector.clear()
	main_buttons.visible = false
	action_options_menu.visible = true
	action_selector.grab_focus()
	action_selector.select(-1)
	action_selector.add_item("Select Action Below", 0)
	for i in range(actions.size()):
		var ma := actions[i] as MercyAction
		action_selector.add_item(ma.action_name, i+1)
	var idx := -1
	idx = yield(action_selector, "item_selected") -1
	print("selected index %s" % idx)
	var mercy_action = actions[idx] as MercyAction
	queue.do_mercy_action(mercy_action)
	yield(DynamicDialogue.create_dialogue(self, [mercy_action.action_performed_message]), "completed")
	action_options_menu.visible = false
	main_buttons.visible = true

func _on_BtnAttack_pressed() -> void:
	cur_choice = Choice.ATTACK

func _on_BtnAction_pressed() -> void:
	cur_choice = Choice.ACTION

func _on_BtnSpare_pressed() -> void:
	cur_choice = Choice.SPARE

func enable():
	visible = true
	var focus_btn := $"HBoxContainer/BtnAttack/DefaultFocusItem"
	focus_btn.activate()

func disable():
	visible = false
