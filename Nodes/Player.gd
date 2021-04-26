extends Area2D

var tile_size = 160
var delay_time = 0.75
var game

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

func move(dir: Vector2):
	var initial_position = position

	dir *= tile_size

	$RayCastImmovable.cast_to = dir
	$RayCastImmovable.force_raycast_update()
	if $RayCastImmovable.is_colliding():
		print("collision")

		$Tween.interpolate_property(self, "position",
			position, position + dir * 0.2,
			delay_time * 0.9, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		yield(wait_for_tween(), "completed")

		$Tween.interpolate_property(self, "position",
			position, initial_position,
			delay_time * 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		yield(wait_for_tween(), "completed")

		return

	$Tween.interpolate_property(self, "position",
		position, position + dir,
		delay_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	yield(wait_for_tween(), "completed")

	var object = get_object_on_top()
	if object != null:
		yield(object.interact(game, self), "completed")

func get_object_on_top():
	$RayCastInteractable.force_raycast_update()
	return $RayCastInteractable.get_collider()

func apply_action(game, action):
	self.game = game

	match action:
		Actions.WalkUp:
			yield(move(Vector2.UP), "completed")
		Actions.WalkDown:
			yield(move(Vector2.DOWN), "completed")
		Actions.WalkLeft:
			yield(move(Vector2.LEFT), "completed")
		Actions.WalkRight:
			yield(move(Vector2.RIGHT), "completed")
		Actions.Converse:
			var object = get_object_on_top()
			if object == null:
				yield(game.read_random_dialog(), "completed")
			else:
				yield(object.converse(game, self), "completed")
		Actions.StrapOn:
			$AudioStrapOneOn.play()
			var object = get_object_on_top()
			if object == null:
#				yield($AudioStrapOneOn, "finished")
				yield(game.read_dialog("What are you trying to strap one on?"), "completed")
			else:
				yield(object.strap_one_on(game, self), "completed")
		Actions.Destroy:
			var object = get_object_on_top()
			if object == null:
				yield(game.read_dialog("You destroy the emptiness,\nbut it only creates more emptiness"), "completed")
			else:
				yield(object.destroy(game, self), "completed")
		Actions.Introspection:
			var object = get_object_on_top()
			if object == null:
				yield(game.read_dialog("You look within yourself,\nand you are satisfied"), "completed")
			else:
				yield(object.introspect(game, self), "completed")
		var _other:
			yield(game.read_dialog("unmatched action! %s" % action), "completed")

func wait_for_tween():
	$Tween.start()
	yield($Tween, "tween_all_completed")
