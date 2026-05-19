extends Node2D

var character_data = []
var challenge_data = []
var niche_data = []

func _on_characters_toggled(toggled_on: bool) -> void:
	$"%Welcome".hide()
	$"%CharactersContainer".show()
	$"%ViewPanel".deactivate()

func _on_characters_saved():
	character_data.clear()
	$"%CharacterList".clear()
	for file in Custom.character_files:
		var data = FileAccess.get_file_as_string("user://custom/characters/data/"+file)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed != null:
				parsed["filepath"] = file
				character_data.append(parsed)
	for data in character_data:
		$"%CharacterList".add_item(data["name"] + " (" + data["filepath"] + ")")
	$"%ViewPanel".deactivate()

func _on_character_file_created(data: Dictionary):
	character_data.append(data)
	var index = $"%CharacterList".add_item(data["name"] + " (" + data["filepath"] + ")")
	$"%CharacterList".select(index)
	$"%ViewPanel"._on_character_selected(data)

func _ready() -> void:
	$"%CharactersContainer".connect("character_file_created", _on_character_file_created)
	$"%CharactersContainer".connect("character_file_saved", _on_characters_saved)
	for file in Custom.character_files:
		var data = FileAccess.get_file_as_string("user://custom/characters/data/"+file)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed != null:
				parsed["filepath"] = file
				character_data.append(parsed)
	for file in Custom.challenge_files:
		var data = FileAccess.get_file_as_string("user://custom/challenges/"+file)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed != null:
				parsed["filepath"] = file
				challenge_data.append(parsed)
	for file in Custom.niche_files:
		var data = FileAccess.get_file_as_string("user://custom/niche/"+file)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed != null:
				parsed["filepath"] = file
				niche_data.append(parsed)
	
	for data in character_data:
		$"%CharacterList".add_item(data["name"] + " (" + data["filepath"] + ")")

func _on_character_list_item_selected(index: int) -> void:
	var data = character_data[index]
	$"%ViewPanel"._on_character_selected(data)


func _on_folder_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://custom/"))


func _on_main_menu_pressed() -> void:
	OS.set_restart_on_exit(true)
	get_tree().quit()
