extends TabContainer

@onready var general = $General
@onready var bonus_objectives = $"Bonus Objectives"
@onready var challenge_chance_label = $General/ChallengeChance/Label
@onready var challenge_chance = $General/ChallengeChance
@onready var niche_chance_label = $General/NicheChance/Label
@onready var niche_chance = $General/NicheChance

func _ready() -> void:
	setup_settings()

func _process(delta: float) -> void:
	challenge_chance_label.text = "Probability to roll a challenge: " + str(challenge_chance.value) + "%"
	niche_chance_label.text = "Probability to roll a niche achievement: " + str(niche_chance.value) + "%"

func setup_settings():
	var keys = Global.save.get_section_keys("RollSettings")
	for key in keys:
		match key:
			"Include normal characters in pool":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(0, false)
				else:
					general.deselect(0)
			"Include tainted characters in pool":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(1, false)
				else:
					general.deselect(1)
			"Include challenges in pool":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(2, false)
				else:
					general.deselect(2)
			"Include niche achievements in pool":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(3, false)
				else:
					general.deselect(3)
			"Prefer 5 Nights At Mom's over niche achievements":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(4, false)
				else:
					general.deselect(4)
			"Suggest best characters for niche achievements":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(5, false)
				else:
					general.deselect(5)
			"Include Boss Rush & Hush as primary objectives":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(6, false)
				else:
					general.deselect(6)
			"True random (include runs without unlocks)":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(7, false)
				else:
					general.deselect(7)
			"ULTRA RANDOM (include EVERYTHING)":
				if Global.load_value_from_save("RollSettings", key) == true:
					general.select(8, false)
				else:
					general.deselect(8)
			"Challenge Chance":
				if Global.load_value_from_save("RollSettings", key, null) != null:
					challenge_chance.value = Global.load_value_from_save("RollSettings", key)
				else:
					challenge_chance.value = 30
			"Niche Chance":
				if Global.load_value_from_save("RollSettings", key, null) != null:
					niche_chance.value = Global.load_value_from_save("RollSettings", key)
				else:
					niche_chance.value = 10
			"Allow Boss Rush as a bonus objective":
				if Global.load_value_from_save("RollSettings", key) == true:
					bonus_objectives.select(0, false)
				else:
					bonus_objectives.deselect(0)
			"Allow Hush as a bonus objective":
				if Global.load_value_from_save("RollSettings", key) == true:
					bonus_objectives.select(1, false)
				else:
					bonus_objectives.deselect(1)
			"Allow Alt Path as a bonus objective":
				if Global.load_value_from_save("RollSettings", key) == true:
					bonus_objectives.select(2, false)
				else:
					bonus_objectives.deselect(2)
			"Allow Devils & Angels as a bonus objective":
				if Global.load_value_from_save("RollSettings", key) == true:
					bonus_objectives.select(3, false)
				else:
					bonus_objectives.deselect(3)

func _on_general_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	Global.save_to_savefile(Global.current_save_file, "RollSettings", general.get_item_text(index), selected)

func _on_bonus_objectives_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	Global.save_to_savefile(Global.current_save_file, "RollSettings", bonus_objectives.get_item_text(index), selected)

func _on_challenge_chance_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Global.save_to_savefile(Global.current_save_file, "RollSettings", "Challenge Chance", challenge_chance.value)

func _on_niche_chance_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Global.save_to_savefile(Global.current_save_file, "RollSettings", "Niche Chance", niche_chance.value)
