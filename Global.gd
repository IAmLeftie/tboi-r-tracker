extends Node

var config = ConfigFile.new()
var save = ConfigFile.new()

var music_volume
var sfx_volume
var current_save_file = null

var mute = false

@onready var popup_window = load("res://Scenes/PopupWindow.tscn")

func _ready() -> void:
	# look for a config file
	var err = config.load("user://settings.cfg")
	
	if err != OK:
		setup_config_file()
		config.load("user://settings.cfg")
	
	for setting in config.get_sections():
		if setting == "Volume":
			music_volume = config.get_value(setting, "Music")
			sfx_volume = config.get_value(setting, "SFX")
		if setting == "Save":
			current_save_file = config.get_value(setting, "CurrentSave")
	
	if current_save_file != null:
		load_save_file(current_save_file)
		savefile_update_pipeline(current_save_file)
		
func savefile_update_pipeline(id: int):
	var err = save.load("user://save" + str(id) + ".sav")
	
	if err != OK:
		setup_save_file(id)
		save.load("user://save" + str(id) + ".sav")
		
	# alpha 0.2.0 - 5 Nights At Mom's Support
	if save.get_value("5NAM", "Current5NAMStreak", null) == null:
		save.set_value("5NAM", "Current5NAMStreak", 0)
	if save.get_value("5NAM", "5NAMStreakCharacters", null) == null:
		save.set_value("5NAM", "5NAMStreakCharacters", [])
	if save.get_value("RollSettings", "Prefer 5 Nights At Mom's over niche achievements", null) == null:
		save.set_value("RollSettings", "Prefer 5 Nights At Mom's over niche achievements", true)
	
	# beta 0.3.0 - custom content support, notepad
	if save.get_value("Notes", "Notes", null) == null:
		save.set_value("Notes", "Notes", "")
	
	save.save("user://save" + str(id) + ".sav")
	
func setup_config_file():
	config.set_value("Volume", "Music", 1)
	config.set_value("Volume", "SFX", 1)
	config.set_value("Save", "CurrentSave", 1)
	
	config.save("user://settings.cfg")
	
func save_to_settings(category: String, key: String, value):
	var err = config.load("user://settings.cfg")
	
	if err != OK:
		setup_config_file()
		config.load("user://settings.cfg")
	
	config.set_value(category, key, value)
	
	config.save("user://settings.cfg")
	
	
func save_to_savefile(id: int, category: String, key: String, value):
	var err = save.load("user://save" + str(id) + ".sav")
	
	if err != OK:
		setup_save_file(id)
		save.load("user://save" + str(id) + ".sav")
	
	save.set_value(category, key, value)
	
	save.save("user://save" + str(id) + ".sav")

func load_save_file(id = 1):
	var err = save.load("user://save" + str(id) + ".sav")
	
	if err != OK:
		setup_save_file(id)
		save.load("user://save" + str(id) + ".sav")
	
	current_save_file = id

func load_value_from_save(category: String, key: String, default: Variant = null):
	var value = save.get_value(category, key, null)
	# If the value is null, we need to try to update the save file
	if value == null:
		savefile_update_pipeline(current_save_file)
		value = save.get_value(category, key, default)
	return value

func get_remaining_marks_for_character(name: String):
	var complete_postit = ["MomsHeart", "MomsHeartHard", "Isaac", "IsaacHard", "BlueBaby", "BlueBabyHard", "Satan", "SatanHard", "Lamb", "LambHard", "MegaSatan", "MegaSatanHard", "BossRush", "BossRushHard", "Hush", "HushHard", "Mother", "MotherHard", "Beast", "BeastHard", "Delirium", "DeliriumHard", "UltraGreed", "UltraGreedier"]
	var category_name = "CharacterMarks"
	if name.contains("Tainted"):
		category_name = "TaintedMarks"
	var postit = load_value_from_save(category_name, name, [])
	var remaining_marks = complete_postit
	for mark in postit:
		var index = remaining_marks.find(mark)
		if index != -1:
			remaining_marks.remove_at(index)
	print(remaining_marks)
	return remaining_marks

func get_unlocked_bosses():
	var bosses = []
	
	if load_value_from_save("Miscellaneous", "BeatenMom") == false:
		bosses.append("Mom")
	else:
		if load_value_from_save("UnlockedBosses", "???"): bosses.append("BlueBaby")
		if load_value_from_save("UnlockedBosses", "The Lamb"): bosses.append("Lamb")
		if load_value_from_save("UnlockedBosses", "Mega Satan"): bosses.append("MegaSatan")
		if load_value_from_save("UnlockedBosses", "Delirium"): bosses.append("Delirium")
		if load_value_from_save("UnlockedBosses", "Mother"): bosses.append("Mother")
		if load_value_from_save("UnlockedBosses", "The Beast"): bosses.append("Beast")
		
		if load_value_from_save("UnlockedBosses", "???") == false and load_value_from_save("UnlockedBosses", "Isaac") == true: bosses.append("Isaac")
		if load_value_from_save("UnlockedBosses", "The Lamb") == false and load_value_from_save("UnlockedBosses", "Satan") == true: bosses.append("Satan")
		
		if load_value_from_save("UnlockedBosses", "Mom's Heart / It Lives!") == true and load_value_from_save("UnlockedCharacters", "???") == false: bosses.append("MomsHeart")
		
		if load_value_from_save("RollSettings", "Allow Hush as a bonus objective") == true and load_value_from_save("UnlockedBosses", "Hush") == true: bosses.append("Hush")
		if load_value_from_save("RollSettings", "Allow Boss Rush as a bonus objective") == true and load_value_from_save("UnlockedBosses", "Boss Rush") == true: bosses.append("BossRush")
	
	if load_value_from_save("UnlockedBosses", "Ultra Greedier") == false and load_value_from_save("UnlockedBosses", "Ultra Greed") == true: bosses.append("UltraGreed")
	if load_value_from_save("UnlockedBosses", "Ultra Greedier"): bosses.append("UltraGreedier")

	return bosses


func get_unlocked_characters():
	var characters = []
	if load_value_from_save("UnlockedCharacters", "Isaac"): characters.append("Isaac")
	if load_value_from_save("UnlockedCharacters", "Magdalene"): characters.append("Magdalene")
	if load_value_from_save("UnlockedCharacters", "Cain"): characters.append("Cain")
	if load_value_from_save("UnlockedCharacters", "Judas"): characters.append("Judas")
	if load_value_from_save("UnlockedCharacters", "???"): characters.append("???")
	if load_value_from_save("UnlockedCharacters", "Eve"): characters.append("Eve")
	if load_value_from_save("UnlockedCharacters", "Samson"): characters.append("Samson")
	if load_value_from_save("UnlockedCharacters", "Azazel"): characters.append("Azazel")
	if load_value_from_save("UnlockedCharacters", "Lazarus"): characters.append("Lazarus")
	if load_value_from_save("UnlockedCharacters", "Eden"): characters.append("Eden")
	if load_value_from_save("UnlockedCharacters", "The Lost"): characters.append("The Lost")
	if load_value_from_save("UnlockedCharacters", "Lilith"): characters.append("Lilith")
	if load_value_from_save("UnlockedCharacters", "Keeper"): characters.append("Keeper")
	if load_value_from_save("UnlockedCharacters", "Apollyon"): characters.append("Apollyon")
	if load_value_from_save("UnlockedCharacters", "The Forgotten"): characters.append("The Forgotten")
	if load_value_from_save("UnlockedCharacters", "Bethany"): characters.append("Bethany")
	if load_value_from_save("UnlockedCharacters", "Jacob & Esau"): characters.append("Jacob & Esau")
	if load_value_from_save("UnlockedTainted", "Tainted Isaac"): characters.append("Tainted Isaac")
	if load_value_from_save("UnlockedTainted", "Tainted Magdalene"): characters.append("Tainted Magdalene")
	if load_value_from_save("UnlockedTainted", "Tainted Cain"): characters.append("Tainted Cain")
	if load_value_from_save("UnlockedTainted", "Tainted Judas"): characters.append("Tainted Judas")
	if load_value_from_save("UnlockedTainted", "Tainted ???"): characters.append("Tainted ???")
	if load_value_from_save("UnlockedTainted", "Tainted Eve"): characters.append("Tainted Eve")
	if load_value_from_save("UnlockedTainted", "Tainted Samson"): characters.append("Tainted Samson")
	if load_value_from_save("UnlockedTainted", "Tainted Azazel"): characters.append("Tainted Azazel")
	if load_value_from_save("UnlockedTainted", "Tainted Lazarus"): characters.append("Tainted Lazarus")
	if load_value_from_save("UnlockedTainted", "Tainted Eden"): characters.append("Tainted Eden")
	if load_value_from_save("UnlockedTainted", "Tainted Lost"): characters.append("Tainted Lost")
	if load_value_from_save("UnlockedTainted", "Tainted Lilith"): characters.append("Tainted Lilith")
	if load_value_from_save("UnlockedTainted", "Tainted Keeper"): characters.append("Tainted Keeper")
	if load_value_from_save("UnlockedTainted", "Tainted Apollyon"): characters.append("Tainted Apollyon")
	if load_value_from_save("UnlockedTainted", "Tainted Forgotten"): characters.append("Tainted Forgotten")
	if load_value_from_save("UnlockedTainted", "Tainted Bethany"): characters.append("Tainted Bethany")
	if load_value_from_save("UnlockedTainted", "Tainted Jacob"): characters.append("Tainted Jacob")
	
	#modded check
	for custom in Custom.custom_characters:
		if load_value_from_save("UnlockedCharacters", custom["name"], null) == true: characters.append(custom["name"])
		elif load_value_from_save("UnlockedTainted", custom["name"], null) == true: characters.append(custom["name"])
	
	return characters

func get_incomplete_challenges(ultra_random = false):
	var challenges = []
	for key in save.get_section_keys("Challenges"):
		var value = load_value_from_save("Challenges", key)
		if ultra_random:
			if value[0] == true:
				challenges.append(key)
		else:
			if value[0] == true and value[1] == false:
				challenges.append(key)
	print(challenges)
	return challenges
	
func get_incomplete_niche_challenges(ultra_random = false):
	var niche = []
	if ultra_random: 
		niche.append_array(["Zip", "It's The Key"])
		for custom in Custom.custom_niche:
			niche.append(custom["name"])
	if load_value_from_save("Miscellaneous", "Zip", null) == false:
		niche.append("Zip")
	if load_value_from_save("Miscellaneous", "ItsTheKey", null) == false:
		niche.append("It's The Key")
	for custom in Custom.custom_niche:
		if load_value_from_save("Miscellaneous", custom["name"], null) == false:
			niche.append(custom["name"])
	print(niche)
	return niche

func get_5NAM_incomplete():
	return load_value_from_save("Miscellaneous", "5NightsAtMoms", false)

func setup_save_file(id = 1):
	save.set_value("UnlockedCharacters", "Isaac", true)
	save.set_value("UnlockedCharacters", "Magdalene", false)
	save.set_value("UnlockedCharacters", "Cain", false)
	save.set_value("UnlockedCharacters", "Judas", false)
	save.set_value("UnlockedCharacters", "???", false)
	save.set_value("UnlockedCharacters", "Eve", false)
	save.set_value("UnlockedCharacters", "Samson", false)
	save.set_value("UnlockedCharacters", "Azazel", false)
	save.set_value("UnlockedCharacters", "Lazarus", false)
	save.set_value("UnlockedCharacters", "Eden", false)
	save.set_value("UnlockedCharacters", "The Lost", false)
	save.set_value("UnlockedCharacters", "Lilith", false)
	save.set_value("UnlockedCharacters", "Keeper", false)
	save.set_value("UnlockedCharacters", "Apollyon", false)
	save.set_value("UnlockedCharacters", "The Forgotten", false)
	save.set_value("UnlockedCharacters", "Bethany", false)
	save.set_value("UnlockedCharacters", "Jacob & Esau", false)
	
	save.set_value("UnlockedTainted", "Tainted Isaac", false)
	save.set_value("UnlockedTainted", "Tainted Magdalene", false)
	save.set_value("UnlockedTainted", "Tainted Cain", false)
	save.set_value("UnlockedTainted", "Tainted Judas", false)
	save.set_value("UnlockedTainted", "Tainted ???", false)
	save.set_value("UnlockedTainted", "Tainted Eve", false)
	save.set_value("UnlockedTainted", "Tainted Samson", false)
	save.set_value("UnlockedTainted", "Tainted Azazel", false)
	save.set_value("UnlockedTainted", "Tainted Lazarus", false)
	save.set_value("UnlockedTainted", "Tainted Eden", false)
	save.set_value("UnlockedTainted", "Tainted Lost", false)
	save.set_value("UnlockedTainted", "Tainted Lilith", false)
	save.set_value("UnlockedTainted", "Tainted Keeper", false)
	save.set_value("UnlockedTainted", "Tainted Apollyon", false)
	save.set_value("UnlockedTainted", "Tainted Forgotten", false)
	save.set_value("UnlockedTainted", "Tainted Bethany", false)
	save.set_value("UnlockedTainted", "Tainted Jacob", false)
	
	save.set_value("UnlockedBosses", "Mom", true)
	save.set_value("UnlockedBosses", "Mom's Heart / It Lives!", false)
	save.set_value("UnlockedBosses", "Isaac", false)
	save.set_value("UnlockedBosses", "Satan", false)
	save.set_value("UnlockedBosses", "???", false)
	save.set_value("UnlockedBosses", "The Lamb", false)
	save.set_value("UnlockedBosses", "Boss Rush", true)
	save.set_value("UnlockedBosses", "Hush", false)
	save.set_value("UnlockedBosses", "Mega Satan", false)
	save.set_value("UnlockedBosses", "Delirium", false)
	save.set_value("UnlockedBosses", "Mother", false)
	save.set_value("UnlockedBosses", "The Beast", false)
	save.set_value("UnlockedBosses", "Ultra Greed", true)
	save.set_value("UnlockedBosses", "Ultra Greedier", false)
	
	save.set_value("CharacterMarks", "Isaac", [])
	save.set_value("CharacterMarks", "Magdalene", [])
	save.set_value("CharacterMarks", "Cain", [])
	save.set_value("CharacterMarks", "Judas", [])
	save.set_value("CharacterMarks", "???", [])
	save.set_value("CharacterMarks", "Eve", [])
	save.set_value("CharacterMarks", "Samson", [])
	save.set_value("CharacterMarks", "Azazel", [])
	save.set_value("CharacterMarks", "Lazarus", [])
	save.set_value("CharacterMarks", "Eden", [])
	save.set_value("CharacterMarks", "The Lost", [])
	save.set_value("CharacterMarks", "Lilith", [])
	save.set_value("CharacterMarks", "Keeper", [])
	save.set_value("CharacterMarks", "Apollyon", [])
	save.set_value("CharacterMarks", "The Forgotten", [])
	save.set_value("CharacterMarks", "Bethany", [])
	save.set_value("CharacterMarks", "Jacob & Esau", [])
	
	save.set_value("TaintedMarks", "Tainted Isaac", [])
	save.set_value("TaintedMarks", "Tainted Magdalene", [])
	save.set_value("TaintedMarks", "Tainted Cain", [])
	save.set_value("TaintedMarks", "Tainted Judas", [])
	save.set_value("TaintedMarks", "Tainted ???", [])
	save.set_value("TaintedMarks", "Tainted Eve", [])
	save.set_value("TaintedMarks", "Tainted Samson", [])
	save.set_value("TaintedMarks", "Tainted Azazel", [])
	save.set_value("TaintedMarks", "Tainted Lazarus", [])
	save.set_value("TaintedMarks", "Tainted Eden", [])
	save.set_value("TaintedMarks", "Tainted Lost", [])
	save.set_value("TaintedMarks", "Tainted Lilith", [])
	save.set_value("TaintedMarks", "Tainted Keeper", [])
	save.set_value("TaintedMarks", "Tainted Apollyon", [])
	save.set_value("TaintedMarks", "Tainted Forgotten", [])
	save.set_value("TaintedMarks", "Tainted Bethany", [])
	save.set_value("TaintedMarks", "Tainted Jacob", [])

	save.set_value("Challenges", "Pitch Black", [true, false])
	save.set_value("Challenges", "High Brow", [true, false])
	save.set_value("Challenges", "Head Trauma", [true, false])
	save.set_value("Challenges", "Darkness Falls", [false, false])
	save.set_value("Challenges", "The Tank", [false, false])
	save.set_value("Challenges", "Solar System", [false, false])
	save.set_value("Challenges", "Suicide King", [false, false])
	save.set_value("Challenges", "Cat Got Your Tongue?", [false, false])
	save.set_value("Challenges", "Demo Man", [false, false])
	save.set_value("Challenges", "Cursed!", [false, false])
	save.set_value("Challenges", "Glass Cannon", [false, false])
	save.set_value("Challenges", "When Life Gives You Lemons", [true, false])
	save.set_value("Challenges", "BEANS!", [true, false])
	save.set_value("Challenges", "It's In The Cards", [true, false])
	save.set_value("Challenges", "Slow Roll", [true, false])
	save.set_value("Challenges", "Computer Savvy", [true, false])
	save.set_value("Challenges", "Waka Waka", [true, false])
	save.set_value("Challenges", "The Host", [true, false])
	save.set_value("Challenges", "The Family Man", [false, false])
	save.set_value("Challenges", "Purist", [false, false])
	save.set_value("Challenges", "XXXXXXXXL", [false, false])
	save.set_value("Challenges", "SPEED!", [false, false])
	save.set_value("Challenges", "Blue Bomber", [false, false])
	save.set_value("Challenges", "PAY TO PLAY", [false, false])
	save.set_value("Challenges", "Have A Heart", [false, false])
	save.set_value("Challenges", "I RULE!", [false, false])
	save.set_value("Challenges", "BRAINS!", [false, false])
	save.set_value("Challenges", "PRIDE DAY!", [false, false])
	save.set_value("Challenges", "Onan's Streak", [false, false])
	save.set_value("Challenges", "The Guardian", [false, false])
	save.set_value("Challenges", "Backasswards", [false, false])
	save.set_value("Challenges", "April's Fool", [false, false])
	save.set_value("Challenges", "Pokey Mans", [false, false])
	save.set_value("Challenges", "Ultra Hard", [false, false])
	save.set_value("Challenges", "Pong", [false, false])
	save.set_value("Challenges", "Scat Man", [true, false])
	save.set_value("Challenges", "Bloody Mary", [false, false])
	save.set_value("Challenges", "Baptism By Fire", [false, false])
	save.set_value("Challenges", "Isaac's Awakening", [false, false])
	save.set_value("Challenges", "Seeing Double", [false, false])
	save.set_value("Challenges", "Pica Run", [false, false])
	save.set_value("Challenges", "Hot Potato", [false, false])
	save.set_value("Challenges", "Cantripped!", [false, false])
	save.set_value("Challenges", "Red Redemption", [false, false])
	save.set_value("Challenges", "DELETE THIS", [false, false])
	
	save.set_value("Miscellaneous", "BeatenMom", false)
	save.set_value("Miscellaneous", "DailyWinStreak", 0)
	save.set_value("Miscellaneous", "DailiesPlayed", 0)
	save.set_value("Miscellaneous", "CrackedCrownUnlocked", false)
	save.set_value("Miscellaneous", "BrokenModemUnlocked", false)
	save.set_value("Miscellaneous", "HorfUnlocked", false)
	save.set_value("Miscellaneous", "5NightsAtMoms", false)
	save.set_value("Miscellaneous", "Zip", false)
	save.set_value("Miscellaneous", "ItsTheKey", false)
	
	save.set_value("RollSettings", "Include normal characters in pool", true)
	save.set_value("RollSettings", "Include tainted characters in pool", true)
	save.set_value("RollSettings", "Include challenges in pool", true)
	save.set_value("RollSettings", "Include niche achievements in pool", true)
	save.set_value("RollSettings", "Prefer 5 Nights At Mom's over niche achievements", true)
	save.set_value("RollSettings", "Suggest best characters for niche achievements", true)
	save.set_value("RollSettings", "Include Boss Rush & Hush as primary objectives", true)
	save.set_value("RollSettings", "True random (include runs without unlocks)", false)
	save.set_value("RollSettings", "ULTRA RANDOM (include EVERYTHING)", false)
	save.set_value("RollSettings", "Challenge Chance", 30.0)
	save.set_value("RollSettings", "Niche Chance", 10.0)
	save.set_value("RollSettings", "Allow Boss Rush as a bonus objective", true)
	save.set_value("RollSettings", "Allow Hush as a bonus objective", true)
	save.set_value("RollSettings", "Allow Alt Path as a bonus objective", false)
	save.set_value("RollSettings", "Allow Devils & Angels as a bonus objective", false)
	
	# alpha 0.2.0 - 5 Nights At Mom's Support
	save.set_value("5NAM", "Current5NAMStreak", 0)
	save.set_value("5NAM", "5NAMStreakCharacters", [])
	
	# beta 0.3.0 - custom content support, notepad
	save.set_value("Notes", "Notes", "")
	
	save.save("user://save" + str(id) + ".sav")
	
	
func create_popup(x: float, y: float, text: String):
	var popup = popup_window.instantiate()
	popup.position = Vector2(x, y)
	popup.init(text)
	get_tree().root.add_child(popup)
	
	
