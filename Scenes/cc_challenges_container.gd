extends Control

signal challenge_file_created(data: Dictionary)
signal challenge_file_saved()

@onready var file_dialog = $FileDialog
var selected_index = -1

var active = false

func activate():
	active = true

func deactivate():
	active = false

func _process(delta: float) -> void:
	visible = active

func _on_new_pressed() -> void:
	file_dialog.current_dir = "user://custom/challenges"
	file_dialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	var parsed = path.split("/")
	var filepath = parsed[parsed.size() - 1]
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string("""{
  "enabled": "false",
  "name": "Example",
  "character": "Isaac",
  "boss": "Mom"
}""")
	file.close()
	emit_signal("challenge_file_created", { "enabled": "false", "name": "Example", "character": "Isaac", "boss": "Mom", "filepath": filepath})

func _on_challenge_list_item_selected(index: int) -> void:
	selected_index = index

func _on_save_button_pressed() -> void:
	if not active: return
	DirAccess.remove_absolute("user://custom/challenges/"+Custom.challenge_files[selected_index])
	var file = FileAccess.open("user://custom/challenges/"+Custom.challenge_files[selected_index], FileAccess.WRITE)
	var string = """{
  "enabled": "{enabled}",
  "name": "{name}",
  "character": "{character}",
  "boss": "{boss}"
}"""
	var data = {
		"enabled": $"%EnabledField".get_value(),
		"name": $"%NameField".get_value(),
		"character": $"%CharacterField".get_value(),
		"boss": $"%BossField".get_value()
	}
	
	file.store_string(string.format(data))
	file.close()
	Global.create_popup(638, 645, "File saved!")
	emit_signal("challenge_file_saved")


func _on_delete_button_pressed() -> void:
	if not active: return
	$"%ConfirmationDialog".popup()


func _on_confirmation_dialog_confirmed() -> void:
	if not active: return
	DirAccess.remove_absolute("user://custom/challenges/"+Custom.challenge_files[selected_index])
	Custom.challenge_files.remove_at(selected_index)
	Global.create_popup(638, 645, "File deleted!")
	emit_signal("challenge_file_saved")
