extends Area2D

export(Array, String, MULTILINE) var interact_dialog
export(Array, String, MULTILINE) var converse_dialog
export(Array, String, MULTILINE) var special_dialog_todo

func interact(game, player):
	if converse_dialog.empty():
		yield(get_tree().create_timer(0.0), "timeout")
		return

	for dialog in interact_dialog:
		yield(game.read_dialog(dialog), "completed")

	if not game.has_action(Actions.Converse):
		for dialog in special_dialog_todo:
			yield(game.read_dialog(dialog), "completed")
		yield(game.give_action(Actions.Converse), "completed")

func converse(game, player):
	if converse_dialog.empty():
		yield(game.read_dialog("Missing dialog!"), "completed")
		return

	for dialog in converse_dialog:
		yield(game.read_dialog(dialog), "completed")

	yield(game.give_action(Actions.StrapOn), "completed")
