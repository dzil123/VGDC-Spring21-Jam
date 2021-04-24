extends Panel

enum Actions { WalkUp, WalkDown, StrapOn, Converse }
const ActionTitles := {
	Actions.WalkUp: "Walk Forward",
	Actions.WalkDown: "Walk Backward",
	Actions.StrapOn: "Strap On",
	Actions.Converse: "Converse",
}

export var action_button_node: PackedScene
export var action_label_node: PackedScene

onready var allowed_actions_container := get_node(@"AllowedActions")
onready var selected_actions_container := get_node(@"SelectedActions")

var allowed_actions := [Actions.WalkUp, Actions.StrapOn, Actions.Converse]
var max_actions := 5
var selected_actions := []

func _ready():
	update_allowed_actions()
	update_selected_actions()

func update_allowed_actions():
	for button in allowed_actions_container.get_children():
		button.queue_free()
	for action in allowed_actions:
		var button := action_button_node.instance()
		button.text = ActionTitles[action]
		button.connect("pressed", self, "_on_action_button_pressed", [action])
		
		allowed_actions_container.add_child(button)

func update_selected_actions():
	for label in selected_actions_container.get_children():
		label.queue_free()
	for action in selected_actions:
		var label := action_label_node.instance()
		label.text = ActionTitles[action]
		
		selected_actions_container.add_child(label)

func _on_action_button_pressed(action):
	if selected_actions.size() >= max_actions:
		return
	print(action)
	selected_actions.append(action)
	update_selected_actions()

func _on_ClearButton_pressed():
	selected_actions.clear()
	update_selected_actions()
