extends Node2D

var character_data = []
var challenge_data = []
var niche_data = []

func _on_characters_toggled(toggled_on: bool) -> void:
	$"%Welcome".hide()
	$"%CharactersContainer".activate()
	$"%ChallengesContainer".deactivate()
	$"%NicheContainer".deactivate()
	$"%ViewPanel".deactivate()

func _on_challenges_toggled(toggled_on: bool) -> void:
	$"%Welcome".hide()
	$"%CharactersContainer".deactivate()
	$"%ChallengesContainer".activate()
	$"%NicheContainer".deactivate()
	$"%ViewPanel".deactivate()

func _on_niche_toggled(toggled_on: bool) -> void:
	$"%Welcome".hide()
	$"%CharactersContainer".deactivate()
	$"%ChallengesContainer".deactivate()
	$"%NicheContainer".activate()
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
	Custom.character_files.append(data["filepath"])
	var index = $"%CharacterList".add_item(data["name"] + " (" + data["filepath"] + ")")
	$"%CharacterList".select(index)
	$"%CharactersContainer".selected_index = index
	$"%ViewPanel"._on_character_selected(data)
	
func _on_challenges_saved():
	challenge_data.clear()
	$"%ChallengeList".clear()
	for file in Custom.challenge_files:
		var data = FileAccess.get_file_as_string("user://custom/challenges/"+file)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed != null:
				parsed["filepath"] = file
				challenge_data.append(parsed)
	for data in challenge_data:
		$"%ChallengeList".add_item(data["name"] + " (" + data["filepath"] + ")")
	$"%ViewPanel".deactivate()

func _on_challenge_file_created(data: Dictionary):
	challenge_data.append(data)
	Custom.challenge_files.append(data["filepath"])
	var index = $"%ChallengeList".add_item(data["name"] + " (" + data["filepath"] + ")")
	$"%ChallengeList".select(index)
	$"%ChallengesContainer".selected_index = index
	$"%ViewPanel"._on_challenge_selected(data)
	
func _on_niche_saved():
	niche_data.clear()
	$"%NicheList".clear()
	for file in Custom.niche_files:
		var data = FileAccess.get_file_as_string("user://custom/niche/"+file)
		if data != "":
			var parsed = JSON.parse_string(data)
			if parsed != null:
				parsed["filepath"] = file
				niche_data.append(parsed)
	for data in niche_data:
		$"%NicheList".add_item(data["name"] + " (" + data["filepath"] + ")")
	$"%ViewPanel".deactivate()

func _on_niche_file_created(data: Dictionary):
	niche_data.append(data)
	Custom.niche_files.append(data["filepath"])
	var index = $"%NicheList".add_item(data["name"] + " (" + data["filepath"] + ")")
	$"%NicheList".select(index)
	$"%NicheContainer".selected_index = index
	$"%ViewPanel"._on_niche_selected(data)

func _ready() -> void:
	$"%CharactersContainer".connect("character_file_created", _on_character_file_created)
	$"%CharactersContainer".connect("character_file_saved", _on_characters_saved)
	$"%ChallengesContainer".connect("challenge_file_created", _on_challenge_file_created)
	$"%ChallengesContainer".connect("challenge_file_saved", _on_challenges_saved)
	$"%NicheContainer".connect("niche_file_created", _on_niche_file_created)
	$"%NicheContainer".connect("niche_file_saved", _on_niche_saved)
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
	for data in challenge_data:
		$"%ChallengeList".add_item(data["name"] + " (" + data["filepath"] + ")")
	for data in niche_data:
		$"%NicheList".add_item(data["name"] + " (" + data["filepath"] + ")")

func _on_character_list_item_selected(index: int) -> void:
	var data = character_data[index]
	$"%ViewPanel"._on_character_selected(data)
	
func _on_challenge_list_item_selected(index: int) -> void:
	var data = challenge_data[index]
	$"%ViewPanel"._on_challenge_selected(data)
	
func _on_niche_list_item_selected(index: int) -> void:
	var data = niche_data[index]
	$"%ViewPanel"._on_niche_selected(data)

func _on_folder_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://custom/"))


func _on_main_menu_pressed() -> void:
	OS.set_restart_on_exit(true)
	get_tree().quit()

func _on_welcome_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_wiki_pressed() -> void:
	OS.shell_open("https://github.com/IAmLeftie/tboi-r-tracker/wiki")
