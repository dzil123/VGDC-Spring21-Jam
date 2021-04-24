extends Area2D

onready var ray = $RayCast2D

var tile_size = 64
var delay_time = 0.75

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

func move(dir: Vector2):
	var initial_position = position

	dir *= tile_size

	ray.cast_to = dir
	ray.force_raycast_update()
	if ray.is_colliding():
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

func apply_action(action):
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
		_:
			print("unmatched action! %s" % action)
			yield(get_tree().create_timer(delay_time), "timeout")

func wait_for_tween():
	$Tween.start()
	yield($Tween, "tween_all_completed")
