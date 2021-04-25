extends Panel

signal dialog_completed

var time_per_char = 0.01

func _ready():
	clear()

func clear():
	return
	end_tween()

	$RichTextLabel.bbcode_text = ""
	$RichTextLabel.visible_characters = -1

	$ContinueButton.disabled = true

func end_tween():
	$Tween.stop_all()
	$RichTextLabel.visible_characters = -1

func read_dialog(dialog, speed=1):
	return
	$RichTextLabel.bbcode_text = dialog
	$RichTextLabel.visible_characters = 0
	var num_chars = dialog.length()
	var delay = time_per_char * num_chars / speed

	yield(get_tree().create_timer(0.2), "timeout")

	$Tween.interpolate_property($RichTextLabel, "percent_visible",
		0, 1,
		delay, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	$ContinueButton.disabled = false
	yield(self, "dialog_completed")

	end_tween()
	yield(self, "dialog_completed")

	clear()

#func wait_for_tween():
#	$Tween.start()
#	yield($Tween, "tween_all_completed")

func _on_Tween_tween_all_completed():
	emit_signal("dialog_completed")

func _on_ContinueButton_pressed():
	emit_signal("dialog_completed")

func _on_Main_Game_stop_running():
	clear()

func _on_Main_Game_start_running():
	$ContinueButton.grab_focus()
