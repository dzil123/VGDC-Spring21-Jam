extends Panel

var time_per_char = 0.01

func _ready():
	clear()

func clear():
	$RichTextLabel.bbcode_text = ""
	$RichTextLabel.visible_characters = -1

	$ContinueButton.disabled = true

func read_dialog(dialog):
	$RichTextLabel.bbcode_text = dialog
	$RichTextLabel.visible_characters = 0
	var num_chars = dialog.length()
	var delay = time_per_char * num_chars

	yield(get_tree().create_timer(0.2), "timeout")

	$Tween.interpolate_property($RichTextLabel, "percent_visible",
		0, 1,
		delay, Tween.TRANS_LINEAR, Tween.EASE_IN)
	yield(wait_for_tween(), "completed")

	$RichTextLabel.visible_characters = -1

	$ContinueButton.disabled = false
	yield($ContinueButton, "pressed")
	clear()

func wait_for_tween():
	$Tween.start()
	yield($Tween, "tween_all_completed")
