extends Area2D

export(Array, String, MULTILINE) var interact_dialog
export(Array, String, MULTILINE) var converse_dialog
export(Array, String, MULTILINE) var strap_one_on_dialog
export(Array, String, MULTILINE) var destroy_dialog

func interact(game, player):
	yield(game.read_dialog(interact_dialog), "completed")

func converse(game, player):
	yield(game.read_dialog(converse_dialog), "completed")

	if game.has_action(Actions.StrapOn):
		yield(game.read_dialog("Wait, you already have that..."), "completed")
	yield(game.give_action(Actions.StrapOn), "completed")

func strap_one_on(game, player):
	yield(game.read_dialog(strap_one_on_dialog), "completed")

func destroy(game, player):
	yield(game.read_dialog(destroy_dialog), "completed")