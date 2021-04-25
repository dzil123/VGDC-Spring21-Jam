extends Node

# only ever trigger start_running/stop_running
signal start_running
signal stop_running
signal update_running(is_running)

export(Array, PackedScene) var levels
var current_level: int

var is_running = false

func _ready():
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

	for action in actions:
		print("sending action to player %s" % action)
		yield(get_player().apply_action(self, action), "completed")

	print("done")
	yield(get_tree().create_timer(2.0), "timeout")
	emit_signal("stop_running")

func read_dialog(text):
	yield($GUI/DialogViewer.read_dialog(text), "completed")

# these functions are seperate from start_running/stop_running because
# there might be a reason to veto the buttonpress
func _on_RunButton_pressed():
	emit_signal("start_running")

func _on_StopButton_pressed():
	emit_signal("stop_running")
