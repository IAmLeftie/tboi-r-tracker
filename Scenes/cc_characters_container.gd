extends Control

signal character_file_created(data: Dictionary)
signal character_file_saved()

@onready var file_dialog = $FileDialog
var selected_index = -1

func _on_new_pressed() -> void:
	file_dialog.current_dir = "user://custom/characters/data"
	file_dialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	var parsed = path.split("/")
	var filepath = parsed[parsed.size() - 1]
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string("""{
  "enabled": "false",
  "name": "Example",
  "smallSprite": "example.png",
  "bigSprite": "example.png",
  "hasTaintedVersion": "true",
  "taintedName": "Tainted Example",
  "taintedSmallSprite": "t_example.png",
  "taintedBigSprite": "t_example.png"
}""")
	file.close()
	emit_signal("character_file_created", { "enabled": "false", "name": "Example", "smallSprite": "example.png",
	"bigSprite": "example.png", "hasTaintedVersion": "true", "taintedName": "Tainted Example", "taintedSmallSprite": "t_example.png",
	"taintedBigSprite": "t_example.png", "filepath": filepath})

func _on_character_list_item_selected(index: int) -> void:
	selected_index = index

func _on_save_button_pressed() -> void:
	DirAccess.remove_absolute("user://custom/characters/data/"+Custom.character_files[selected_index])
	var file = FileAccess.open("user://custom/characters/data/"+Custom.character_files[selected_index], FileAccess.WRITE)
	var string = """{
  "enabled": "{enabled}",
  "name": "{name}",
  "smallSprite": "{smallSprite}",
  "bigSprite": "{bigSprite}",
  "hasTaintedVersion": "{hasTaintedVersion}",
  "taintedName": "{taintedName}",
  "taintedSmallSprite": "{taintedSmallSprite}",
  "taintedBigSprite": "{taintedBigSprite}"
}"""
	var data = {
		"enabled": $"%EnabledField".get_value(),
		"name": $"%NameField".get_value(),
		"smallSprite": $"%CharacterSmallSpriteField".get_value(),
		"bigSprite": $"%CharacterBigSpriteField".get_value(),
		"hasTaintedVersion": $"%TaintedField".get_value(),
		"taintedName": $"%TaintedNameField".get_value(),
		"taintedSmallSprite": $"%TCharacterSmallSpriteField".get_value(),
		"taintedBigSprite": $"%TCharacterBigSpriteField".get_value()
	}
	
	file.store_string(string.format(data))
	file.close()
	emit_signal("character_file_saved")


func _on_delete_button_pressed() -> void:
	$"%ConfirmationDialog".popup()


func _on_confirmation_dialog_confirmed() -> void:
	DirAccess.remove_absolute("user://custom/characters/data/"+Custom.character_files[selected_index])
	emit_signal("character_file_saved")
