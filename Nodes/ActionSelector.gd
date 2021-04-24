extends Panel

export var action_button_node: PackedScene
export var action_label_node: PackedScene

onready var allowed_actions_container := get_node(@"AllowedActions")
onready var selected_actions_container := get_node(@"SelectedActions")

# these can be written and set by the game node
var allowed_actions := [Actions.WalkUp, Actions.WalkDown, Actions.WalkLeft, Actions.WalkRight, Actions.StrapOn, Actions.Converse]
var max_actions := 20
var selected_actions := []

func _ready():
	update_allowed_actions()
	update_selected_actions()
	update_running(false)

func update_allowed_actions():
	for button in allowed_actions_container.get_children():
		button.free()
	for action in allowed_actions:
		var button := action_button_node.instance()
		button.text = Actions.Titles[action]
		button.connect("pressed", self, "_on_action_button_pressed", [action])

		allowed_actions_container.add_child(button)

func update_selected_actions():
	for label in selected_actions_container.get_children():
		label.free()
	for action in selected_actions:
		var label := action_label_node.instance()
		label.text = Actions.Titles[action]

		selected_actions_container.add_child(label)

func update_running(is_running):
	$ClearButton.disabled = is_running
	$RunButton.visible = not is_running
	$StopButton.visible = is_running
	allowed_actions_container.propagate_call("set_disabled", [is_running])

func _on_action_button_pressed(action):
	if selected_actions.size() >= max_actions:
		return
	print(action)
	selected_actions.append(action)
	update_selected_actions()

func _on_ClearButton_pressed():
	selected_actions.clear()
	update_selected_actions()
