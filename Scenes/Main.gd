extends Node

# only ever trigger start_running/stop_running
signal start_running
signal stop_running
signal update_running(is_running)

export(Array, PackedScene) var levels
export(Array, String) var empty_dialog
var current_level: int

var is_running = false
var queue_stop = false

func _ready():
	randomize()

	connect("update_running", self, "update_running")
	connect("start_running", self, "start_running")
	connect("stop_running", self, "stop_running")

	assert(levels.size() > 0)
	current_level = 0
	load_level()

func load_level():
	for child in $LevelHolder.get_children():
		child.queue_free()

	var scene = levels[current_level].instance()
	$LevelHolder.add_child(scene)

func update_running(is_running):
	self.is_running = is_running

func start_running():
	run_action_sequence()

func stop_running():
	print("stopping")

	# reset the level to initial state
	load_level()

func get_player():
	return $LevelHolder.get_child(0).get_node("Player")

func run_action_sequence():
	var actions = $GUI/ActionSelector.selected_actions

	var konami_code = [Actions.WalkUp, Actions.WalkUp, Actions.WalkDown, Actions.WalkDown, \
					   Actions.WalkLeft, Actions.WalkRight, Actions.WalkLeft, Actions.WalkRight]
	if actions == konami_code:
		yield(read_dialog("You cheater..."), "completed")
		for action in [Actions.Converse, Actions.StrapOn, Actions.Destroy, Actions.Introspection]:
			yield(give_action(action), "completed")
	else:
		for action_index in range(actions.size()):
			$GUI/ActionSelector.highlight(action_index)
			var action = actions[action_index]

			print("sending action to player %s" % action)
			yield(get_player().apply_action(self, action), "completed")

			if queue_stop:
				queue_stop = false
				print("early stop")
				break

	print("done")
	$GUI/ActionSelector.highlight(-1)
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("stop_running")

# triggerable from the player

func read_dialog(text, speed=1):
	if typeof(text) == TYPE_ARRAY:
		for item in text:
			yield(read_dialog(item, speed), "completed")
		return
	yield($GUI/DialogViewer.read_dialog(text, speed), "completed")

func give_action(action):
	if has_action(action):
		yield(get_tree().create_timer(0.0), "timeout")
		return
	yield(read_dialog("You gain [%s]" % Actions.Titles[action]), "completed")
	$GUI/ActionSelector.allowed_actions.append(action)
	$GUI/ActionSelector.queue_clear = true
	yield(reset_loop(), "completed")

func has_action(action):
	return $GUI/ActionSelector.allowed_actions.find(action) != -1

func read_random_dialog():
	yield(read_dialog(empty_dialog[randi() % empty_dialog.size()]), "completed")

func reset_loop():
	queue_stop = true
	yield(get_tree().create_timer(0.0), "timeout")

# these functions are seperate from start_running/stop_running because
# there might be a reason to veto the buttonpress
func _on_RunButton_pressed():
	emit_signal("start_running")

func _on_StopButton_pressed():
	emit_signal("stop_running")
