extends Control

var open = false
var timer = 0

func init():
	$TextEdit.text = Global.load_value_from_save("Notes", "Notes", "")

func _on_notes_button_pressed() -> void:
	open = !open
	match open:
		true:
			$AnimationPlayer.play("open")
		false:
			$AnimationPlayer.play("close")

func _physics_process(delta: float) -> void:
	if not get_tree().current_scene: return
	if get_tree().current_scene.name == "Main" or get_tree().current_scene.name == "Options": hide()
	else: show()
	if timer > 0:
		timer -= delta
		if timer <= 2.0:
			$ProgressBar.show()
			$ProgressBar.value = 2.0 - timer
		if timer <= 0:
			timer = 0
			Global.save_to_savefile(Global.current_save_file, "Notes", "Notes", $TextEdit.text)
			Global.create_popup(638, 645, "Notes saved!")
			$ProgressBar.value = 0
			$ProgressBar.hide()

func _on_text_edit_text_changed() -> void:
	timer = 3.0
