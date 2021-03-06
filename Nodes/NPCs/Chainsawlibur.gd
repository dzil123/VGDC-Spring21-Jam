extends Area2D

export(Array, String, MULTILINE) var interact_dialog
export(Array, String, MULTILINE) var converse_dialog
export(Array, String, MULTILINE) var strap_one_on_dialog
export(Array, String, MULTILINE) var strap_one_on_already_destroy_dialog
export(Array, String, MULTILINE) var introspect_dialog
export(Array, String, MULTILINE) var destroy_dialog

func interact(game, player):
	yield(game.read_dialog(interact_dialog), "completed")

func converse(game, player):
	yield(game.read_dialog(converse_dialog), "completed")

func strap_one_on(game, player):
	if not game.has_action(Actions.Destroy):
		yield(game.read_dialog(strap_one_on_dialog), "completed")
		yield(game.give_action(Actions.Destroy), "completed")
	else:
		yield(game.read_dialog(strap_one_on_already_destroy_dialog), "completed")
	yield(game.reset_loop(), "completed")

func destroy(game, player):
	yield(game.read_dialog(destroy_dialog), "completed")

func introspect(game, player):
	yield(game.read_dialog(introspect_dialog), "completed")
