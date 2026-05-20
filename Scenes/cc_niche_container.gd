extends Control

signal niche_file_created(data: Dictionary)
signal niche_file_saved()

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
	file_dialog.current_dir = "user://custom/niche"
	file_dialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	var parsed = path.split("/")
	var filepath = parsed[parsed.size() - 1]
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string("""{
  "enabled": "false",
  "name": "Example",
  "suggested_character": "Isaac",
  "boss": "Mom",
  "objective": "Put the achievement objective here."
}""")
	file.close()
	emit_signal("niche_file_created", { "enabled": "false", "name": "Example", "suggested_character": "Isaac", "boss": "Mom", "objective": "Put the achievement objective here.", "filepath": filepath})

func _on_niche_list_item_selected(index: int) -> void:
	selected_index = index

func _on_save_button_pressed() -> void:
	if not active: return
	DirAccess.remove_absolute("user://custom/niche/"+Custom.niche_files[selected_index])
	var file = FileAccess.open("user://custom/niche/"+Custom.niche_files[selected_index], FileAccess.WRITE)
	var string = """{
  "enabled": "{enabled}",
  "name": "{name}",
  "suggested_character": "{character}",
  "boss": "{boss}",
  "objective": "{objective}"
}"""
	var data = {
		"enabled": $"%EnabledField".get_value(),
		"name": $"%NameField".get_value(),
		"character": $"%CharacterField".get_value(),
		"boss": $"%BossField".get_value(),
		"objective": $"%ObjectiveField".get_value()
	}
	
	file.store_string(string.format(data))
	file.close()
	emit_signal("niche_file_saved")


func _on_delete_button_pressed() -> void:
	if not active: return
	$"%ConfirmationDialog".popup()


func _on_confirmation_dialog_confirmed() -> void:
	if not active: return
	DirAccess.remove_absolute("user://custom/niche/"+Custom.niche_files[selected_index])
	emit_signal("niche_file_saved")
