extends Area2D

export(Array, String, MULTILINE) var interact_dialog
export(Array, String, MULTILINE) var converse_dialog
export(Array, String, MULTILINE) var strap_one_on_dialog
export(Array, String, MULTILINE) var gain_converse_dialog

func interact(game, player):
	yield(game.read_dialog(interact_dialog), "completed")

	if not game.has_action(Actions.Converse):
		yield(game.read_dialog(gain_converse_dialog), "completed")
		yield(game.give_action(Actions.Converse), "completed")

func converse(game, player):
	yield(game.read_dialog(converse_dialog), "completed")

func strap_one_on(game, player):
	yield(game.read_dialog(strap_one_on_dialog), "completed")

func destroy(game, player):
	yield(game.read_dialog("Nothing happens"), "completed")

