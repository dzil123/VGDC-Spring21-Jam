extends Area2D

var tile_size = 64
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
		Actions.StrapOn:
			$AudioStrapOneOn.play()
			yield($AudioStrapOneOn, "finished")
		Actions.Converse:
			var object = get_object_on_top()
			if object == null:
				yield(game.read_dialog("But nobody came..."), "completed")
			else:
				yield(object.converse(game, self), "completed")
		_:
			print("unmatched action! %s" % action)
			yield(get_tree().create_timer(delay_time), "timeout")

func wait_for_tween():
	$Tween.start()
	yield($Tween, "tween_all_completed")
