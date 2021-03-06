extends Panel

export var action_button_node: PackedScene
export var action_label_node: PackedScene

onready var allowed_actions_container := get_node(@"AllowedActions")
onready var selected_actions_container := get_node(@"SelectedActions")

# these can be written and set by the game node
var allowed_actions := [Actions.WalkUp, Actions.WalkDown, Actions.WalkLeft, Actions.WalkRight]
var max_actions := 8
var selected_actions := []
var queue_clear = false

func _ready():
	update_allowed_actions()
	update_selected_actions()
	update_running(false)

func update_allowed_actions():
	for button in allowed_actions_container.get_children():
		button.queue_free()
		allowed_actions_container.remove_child(button)
	for action in allowed_actions:
		var button := action_button_node.instance()
		button.text = Actions.Titles[action]
		button.connect("pressed", self, "_on_action_button_pressed", [action])

		allowed_actions_container.add_child(button)

func update_selected_actions():
	for label in selected_actions_container.get_children():
		label.queue_free()
		selected_actions_container.remove_child(label)
#		label.remove_and_skip()
	for action in selected_actions:
		var label := action_label_node.instance()
		label.set_action(action)

		selected_actions_container.add_child(label)

	highlight(-1)

	yield(get_tree(), "idle_frame")

	for label in selected_actions_container.get_children():
		label.rect_size = Vector2.ONE * 80

func update_running(is_running):
	$ClearButton.disabled = is_running
	$RunButton.visible = not is_running
	$StopButton.visible = is_running
	allowed_actions_container.propagate_call("set_disabled", [is_running])

func highlight(index):
	$SelectedActions.propagate_call("highlight", [false])
	if index >= 0 and index < $SelectedActions.get_child_count():
		$SelectedActions.get_child(index).highlight(true)

func _on_action_button_pressed(action):
	if selected_actions.size() >= max_actions:
		return
	print(action)
	selected_actions.append(action)
	update_selected_actions()

func _on_ClearButton_pressed():
	selected_actions.clear()
	update_selected_actions()

func _on_Main_Game_stop_running():
	if queue_clear:
		queue_clear = false
		selected_actions.clear()
		update_selected_actions()

	update_allowed_actions()
	update_running(false)

func _on_Main_Game_start_running():
	update_running(true)
