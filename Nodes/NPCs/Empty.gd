extends Area2D

export(Array, String, MULTILINE) var interact_dialog
export(Array, String, MULTILINE) var gain_introspect_dialog
export(Array, String, MULTILINE) var converse_dialog
export(Array, String, MULTILINE) var strap_one_on_dialog
export(Array, String, MULTILINE) var destroy_dialog
export(Array, String, MULTILINE) var introspect_dialog

func interact(game, player):
	yield(game.read_dialog(interact_dialog), "completed")

	if not game.has_action(Actions.Introspection):
		yield(game.read_dialog(gain_introspect_dialog), "completed")
	yield(game.give_action(Actions.Introspection), "completed")

func converse(game, player):
	yield(game.read_dialog(converse_dialog), "completed")

func strap_one_on(game, player):
	yield(game.read_dialog(strap_one_on_dialog), "completed")

func destroy(game, player):
	yield(game.read_dialog(destroy_dialog), "completed")

func introspect(game, player):
	yield(game.read_dialog(introspect_dialog), "completed")
