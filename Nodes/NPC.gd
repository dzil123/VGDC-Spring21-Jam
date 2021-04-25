extends Area2D

export(Array, String, MULTILINE) var converse_dialog

func interact(game, player):
	print("interacting!")
	yield(get_tree().create_timer(0.0), "timeout")
#	yield(game.read_dialog("this is some text"), "completed")

func converse(game, player):
	if converse_dialog.empty():
		yield(game.read_dialog("Missing dialog!"), "completed")
		return

	for dialog in converse_dialog:
		yield(game.read_dialog(dialog), "completed")
