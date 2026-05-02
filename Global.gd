extends Node

var config = ConfigFile.new()
var save = ConfigFile.new()

var music_volume
var sfx_volume
var current_save_file = null

var mute = false

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

func get_remaining_marks_for_character(name: String):
	var complete_postit = ["MomsHeart", "MomsHeartHard", "Isaac", "IsaacHard", "BlueBaby", "BlueBabyHard", "Satan", "SatanHard", "Lamb", "LambHard", "MegaSatan", "MegaSatanHard", "BossRush", "BossRushHard", "Hush", "HushHard", "Mother", "MotherHard", "Beast", "BeastHard", "Delirium", "DeliriumHard", "UltraGreed", "UltraGreedier"]
	var category_name = "CharacterMarks"
	if name.contains("Tainted"):
		category_name = "TaintedMarks"
	var postit = save.get_value(category_name, name)
	var remaining_marks = complete_postit
	for mark in postit:
		var index = remaining_marks.find(mark)
		if index != -1:
			remaining_marks.remove_at(index)
	print(remaining_marks)
	return remaining_marks

func get_unlocked_bosses():
	var bosses = []
	
	if save.get_value("Miscellaneous", "BeatenMom") == false:
		bosses.append("Mom")
	else:
		if save.get_value("UnlockedBosses", "???"): bosses.append("BlueBaby")
		if save.get_value("UnlockedBosses", "The Lamb"): bosses.append("Lamb")
		if save.get_value("UnlockedBosses", "Mega Satan"): bosses.append("MegaSatan")
		if save.get_value("UnlockedBosses", "Delirium"): bosses.append("Delirium")
		if save.get_value("UnlockedBosses", "Mother"): bosses.append("Mother")
		if save.get_value("UnlockedBosses", "The Beast"): bosses.append("Beast")
		
		if save.get_value("UnlockedBosses", "???") == false and save.get_value("UnlockedBosses", "Isaac") == true: bosses.append("Isaac")
		if save.get_value("UnlockedBosses", "The Lamb") == false and save.get_value("UnlockedBosses", "Satan") == true: bosses.append("Satan")
		
		if save.get_value("UnlockedBosses", "Mom's Heart / It Lives!") == true and save.get_value("UnlockedCharacters", "???") == false: bosses.append("MomsHeart")
		
		if save.get_value("RollSettings", "Allow Hush as a bonus objective") == true and save.get_value("UnlockedBosses", "Hush") == true: bosses.append("Hush")
		if save.get_value("RollSettings", "Allow Boss Rush as a bonus objective") == true and save.get_value("UnlockedBosses", "Boss Rush") == true: bosses.append("BossRush")
	
	if save.get_value("UnlockedBosses", "Ultra Greedier") == false and save.get_value("UnlockedBosses", "Ultra Greed") == true: bosses.append("UltraGreed")
	if save.get_value("UnlockedBosses", "Ultra Greedier"): bosses.append("UltraGreedier")

	return bosses


func get_unlocked_characters():
	var characters = []
	if save.get_value("UnlockedCharacters", "Isaac"): characters.append("Isaac")
	if save.get_value("UnlockedCharacters", "Magdalene"): characters.append("Magdalene")
	if save.get_value("UnlockedCharacters", "Cain"): characters.append("Cain")
	if save.get_value("UnlockedCharacters", "Judas"): characters.append("Judas")
	if save.get_value("UnlockedCharacters", "???"): characters.append("???")
	if save.get_value("UnlockedCharacters", "Eve"): characters.append("Eve")
	if save.get_value("UnlockedCharacters", "Samson"): characters.append("Samson")
	if save.get_value("UnlockedCharacters", "Azazel"): characters.append("Azazel")
	if save.get_value("UnlockedCharacters", "Lazarus"): characters.append("Lazarus")
	if save.get_value("UnlockedCharacters", "Eden"): characters.append("Eden")
	if save.get_value("UnlockedCharacters", "The Lost"): characters.append("The Lost")
	if save.get_value("UnlockedCharacters", "Lilith"): characters.append("Lilith")
	if save.get_value("UnlockedCharacters", "Keeper"): characters.append("Keeper")
	if save.get_value("UnlockedCharacters", "Apollyon"): characters.append("Apollyon")
	if save.get_value("UnlockedCharacters", "The Forgotten"): characters.append("The Forgotten")
	if save.get_value("UnlockedCharacters", "Bethany"): characters.append("Bethany")
	if save.get_value("UnlockedCharacters", "Jacob & Esau"): characters.append("Jacob & Esau")
	if save.get_value("UnlockedTainted", "Tainted Isaac"): characters.append("Tainted Isaac")
	if save.get_value("UnlockedTainted", "Tainted Magdalene"): characters.append("Tainted Magdalene")
	if save.get_value("UnlockedTainted", "Tainted Cain"): characters.append("Tainted Cain")
	if save.get_value("UnlockedTainted", "Tainted Judas"): characters.append("Tainted Judas")
	if save.get_value("UnlockedTainted", "Tainted ???"): characters.append("Tainted ???")
	if save.get_value("UnlockedTainted", "Tainted Eve"): characters.append("Tainted Eve")
	if save.get_value("UnlockedTainted", "Tainted Samson"): characters.append("Tainted Samson")
	if save.get_value("UnlockedTainted", "Tainted Azazel"): characters.append("Tainted Azazel")
	if save.get_value("UnlockedTainted", "Tainted Lazarus"): characters.append("Tainted Lazarus")
	if save.get_value("UnlockedTainted", "Tainted Eden"): characters.append("Tainted Eden")
	if save.get_value("UnlockedTainted", "Tainted Lost"): characters.append("Tainted Lost")
	if save.get_value("UnlockedTainted", "Tainted Lilith"): characters.append("Tainted Lilith")
	if save.get_value("UnlockedTainted", "Tainted Keeper"): characters.append("Tainted Keeper")
	if save.get_value("UnlockedTainted", "Tainted Apollyon"): characters.append("Tainted Apollyon")
	if save.get_value("UnlockedTainted", "Tainted Forgotten"): characters.append("Tainted Forgotten")
	if save.get_value("UnlockedTainted", "Tainted Bethany"): characters.append("Tainted Bethany")
	if save.get_value("UnlockedTainted", "Tainted Jacob"): characters.append("Tainted Jacob")
	
	return characters

func get_incomplete_challenges(ultra_random = false):
	var challenges = []
	for key in save.get_section_keys("Challenges"):
		var value = save.get_value("Challenges", key)
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
	if ultra_random: return ["Zip", "It's The Key"]
	if save.get_value("Miscellaneous", "Zip", null) == false:
		niche.append("Zip")
	if save.get_value("Miscellaneous", "ItsTheKey", null) == false:
		niche.append("It's The Key")
	print(niche)
	return niche

func get_5NAM_incomplete():
	return save.get_value("Miscellaneous", "5NightsAtMoms", false)

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
	
	save.save("user://save" + str(id) + ".sav")
	
	

	
	
