extends Node2D

@onready var character_apollyon = preload("res://Assets/sprites/character/big/apollyon.png")
@onready var character_azazel = preload("res://Assets/sprites/character/big/azazel.png")
@onready var character_bethany = preload("res://Assets/sprites/character/big/bethany.png")
@onready var character_bluebaby = preload("res://Assets/sprites/character/big/bluebaby.png")
@onready var character_cain = preload("res://Assets/sprites/character/big/cain.png")
@onready var character_eden = preload("res://Assets/sprites/character/big/eden.png")
@onready var character_eve = preload("res://Assets/sprites/character/big/eve.png")
@onready var character_forgotten = preload("res://Assets/sprites/character/big/forgotten.png")
@onready var character_isaac = preload("res://Assets/sprites/character/big/isaac.png")
@onready var character_jacobesau = preload("res://Assets/sprites/character/big/jacobesau.png")
@onready var character_judas = preload("res://Assets/sprites/character/big/judas.png")
@onready var character_keeper = preload("res://Assets/sprites/character/big/keeper.png")
@onready var character_lazarus = preload("res://Assets/sprites/character/big/lazarus.png")
@onready var character_lilith = preload("res://Assets/sprites/character/big/lilith.png")
@onready var character_lost = preload("res://Assets/sprites/character/big/lost.png")
@onready var character_magdalene = preload("res://Assets/sprites/character/big/magdalene.png")
@onready var character_samson = preload("res://Assets/sprites/character/big/samson.png")
@onready var character_t_apollyon = preload("res://Assets/sprites/character/big/t_apollyon.png")
@onready var character_t_azazel = preload("res://Assets/sprites/character/big/t_azazel.png")
@onready var character_t_bethany = preload("res://Assets/sprites/character/big/t_bethany.png")
@onready var character_t_bluebaby = preload("res://Assets/sprites/character/big/t_bluebaby.png")
@onready var character_t_cain = preload("res://Assets/sprites/character/big/t_cain.png")
@onready var character_t_eden = preload("res://Assets/sprites/character/big/t_eden/t_eden.tres")
@onready var character_t_eve = preload("res://Assets/sprites/character/big/t_eve.png")
@onready var character_t_forgotten = preload("res://Assets/sprites/character/big/t_forgotten.png")
@onready var character_t_isaac = preload("res://Assets/sprites/character/big/t_isaac.png")
@onready var character_t_jacob = preload("res://Assets/sprites/character/big/t_jacob.png")
@onready var character_t_judas = preload("res://Assets/sprites/character/big/t_judas.png")
@onready var character_t_keeper = preload("res://Assets/sprites/character/big/t_keeper.png")
@onready var character_t_lazarus = preload("res://Assets/sprites/character/big/t_lazarus.png")
@onready var character_t_lilith = preload("res://Assets/sprites/character/big/t_lilith.png")
@onready var character_t_lost = preload("res://Assets/sprites/character/big/t_lost.png")
@onready var character_t_magdalene = preload("res://Assets/sprites/character/big/t_magdalene.png")
@onready var character_t_samson = preload("res://Assets/sprites/character/big/t_samson.png")

@onready var boss_mom = preload("res://Assets/sprites/boss/mom.png")
@onready var boss_momsheart = preload("res://Assets/sprites/boss/momheart.png")
@onready var boss_isaac = preload("res://Assets/sprites/boss/isaac.png")
@onready var boss_bluebaby = preload("res://Assets/sprites/boss/bluebaby.png")
@onready var boss_satan = preload("res://Assets/sprites/boss/satan.png")
@onready var boss_lamb = preload("res://Assets/sprites/boss/lamb.png")
@onready var boss_megasatan = preload("res://Assets/sprites/boss/megasatan.png")
@onready var boss_bossrush = preload("res://Assets/sprites/boss/mom.png") #todo change sprite
@onready var boss_hush = preload("res://Assets/sprites/boss/hush.png")
@onready var boss_mother = preload("res://Assets/sprites/boss/mother.png")
@onready var boss_beast = preload("res://Assets/sprites/boss/beast.png")
@onready var boss_delirium = preload("res://Assets/sprites/boss/delirium.png")
@onready var boss_ultragreed = preload("res://Assets/sprites/boss/ultragreed.png")
@onready var boss_ultragreedier = preload("res://Assets/sprites/boss/ultragreedier.png")

var run_type = "Normal"
var incomplete_challenges = []
var incomplete_niche_achievements = []
var incomplete_5NAM = false
var true_random = false
var ultra_random = false
var suggest_for_niche = false
var beaten_mom = false

var selected_character = "Isaac"
var selected_boss = "Mom"
var bonuses = []

var doing_zip = false
var doing_its_the_key = false
var doing_challenge = ""

var loading_in = true
var loading_out = false

var warning_activated = false
var run_finished = false
var run_won = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"%LoadingRect".modulate.a = 1
	$"AchievementLabel".hide()
	$"%ChallengeDesc".hide()
	$"%Music".volume_linear = Global.music_volume
	$"%PlayerAppear".volume_linear = Global.sfx_volume
	$"%BossAppear".volume_linear = Global.sfx_volume
	true_random = Global.load_value_from_save("RollSettings", "True random (include runs without unlocks)", false)
	ultra_random = Global.load_value_from_save("RollSettings", "ULTRA RANDOM (include EVERYTHING)", false)
	incomplete_challenges = Global.get_incomplete_challenges(ultra_random)
	incomplete_niche_achievements = Global.get_incomplete_niche_challenges(ultra_random)
	incomplete_5NAM = Global.get_5NAM_incomplete()
	suggest_for_niche = Global.load_value_from_save("RollSettings", "Suggest best characters for niche achievements", false)
	beaten_mom = Global.load_value_from_save("Miscellaneous", "BeatenMom", false)
	roll()

func _physics_process(delta: float) -> void:
	if loading_in:
		$"%LoadingRect".modulate.a -= delta
		if $"%LoadingRect".modulate.a <= 0:
			loading_in = false
	if loading_out:
		$"%LoadingRect".modulate.a += delta
		if $"%LoadingRect".modulate.a >= 1:
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_completion_check_mouse_entered() -> void:
	if warning_activated or $"%AnimationPlayer".current_animation == "Primary" or incomplete_5NAM == true or run_type == "Challenge" or run_type == "Niche" or selected_boss.contains("Greed"): return
	$"%AnimationPlayer".play("Warning")
	warning_activated = true

func _on_yes_button_1_pressed() -> void:
	run_finished = true
	$"%AnimationPlayer".play("Warning_2")

func _on_no_button_1_pressed() -> void:
	$"%AnimationPlayer".play("Close_Warning")
	
func _on_yes_button_2_pressed() -> void:
	run_won = true
	$"%AnimationPlayer".play("Close_Warning")
	var streak_characters = Global.load_value_from_save("5NAM", "5NAMStreakCharacters", [])
	var current_streak = Global.load_value_from_save("5NAM", "Current5NAMStreak", 0)
	if streak_characters.find(selected_character) == -1:
		streak_characters.append(selected_character)
		current_streak += 1
		Global.save_to_savefile(Global.current_save_file, "5NAM", "5NAMStreakCharacters", streak_characters)
		Global.save_to_savefile(Global.current_save_file, "5NAM", "Current5NAMStreak", current_streak)
		if current_streak >= 5:
			Global.save_to_savefile(Global.current_save_file, "Miscellaneous", "5NightsAtMoms", true)
			Global.create_popup(638, 645, "Good job on beating 5 Nights At Mom's!")
			await get_tree().create_timer(3.5).timeout
			Global.create_popup(638, 645, "Remember to add your new character unlocks in the main menu!")
		else:
			Global.create_popup(638, 645, "Good job! Added this run to your 5 Nights At Mom's streak.")
			await get_tree().create_timer(3.5).timeout
			Global.create_popup(638, 645, "Remember to add your new character unlocks in the main menu!")
	else:
		Global.save_to_savefile(Global.current_save_file, "5NAM", "5NAMStreakCharacters", [])
		Global.save_to_savefile(Global.current_save_file, "5NAM", "Current5NAMStreak", 0)
		Global.create_popup(638, 645, "Good job! However, this reset your 5 Nights at Mom's streak.")
		await get_tree().create_timer(3.5).timeout
		Global.create_popup(638, 645, "Remember to add your new character unlocks in the main menu!")

func _on_no_button_2_pressed() -> void:
	$"%AnimationPlayer".play("Close_Warning")
	Global.save_to_savefile(Global.current_save_file, "5NAM", "5NAMStreakCharacters", [])
	Global.save_to_savefile(Global.current_save_file, "5NAM", "Current5NAMStreak", 0)
	Global.create_popup(638, 645, "Better luck next time! Your 5 Nights at Mom's streak has been reset.")

func roll():
	var challenge_chance = Global.load_value_from_save("RollSettings", "Challenge Chance", 0)
	var niche_chance = Global.load_value_from_save("RollSettings", "Niche Chance", 0)
	var rand = randi_range(1, 100)
	if rand <= niche_chance and Global.load_value_from_save("RollSettings", "Include niche achievements in pool") == true and (incomplete_5NAM == false and Global.load_value_from_save("RollSettings", "Prefer 5 Nights At Mom's over niche achievements") == false) and (incomplete_niche_achievements.size() > 0 or ultra_random == true):
		run_type = "Niche"
		choose_niche_achievement()
		if not suggest_for_niche:
			choose_character()
	elif rand <= challenge_chance and Global.load_value_from_save("RollSettings", "Include challenges in pool") == true and (incomplete_challenges.size() > 0 or ultra_random == true):
		run_type = "Challenge"
		choose_challenge()
	else:
		run_type = "Normal"
		choose_character()
		choose_boss()
	print(run_type)
	print(selected_character)
	print(selected_boss)
	$AnimationPlayer.play("Primary")

func choose_niche_achievement():
	var rand = randi() % incomplete_niche_achievements.size()
	$"%AchievementLabel".show()
	$"%ChallengeDesc".show()
	match incomplete_niche_achievements[rand]:
		"Zip":
			doing_zip = true
			if suggest_for_niche:
				selected_character = "Azazel"
				assign_character_sprite()
			selected_boss = "Lamb"
			$"%ChallengeName".text = "ZIP!"
			$"%ChallengeDesc".text = "Defeat The Lamb in under 20 minutes."
			assign_boss_sprite()
		"It's The Key":
			doing_its_the_key = true
			if suggest_for_niche:
				selected_character = "Magdalene"
				assign_character_sprite()
			selected_boss = "Lamb"
			$"%ChallengeName".text = "It's The Key"
			$"%ChallengeDesc".text = "Defeat The Lamb without picking up any bombs, coins, or hearts through an entire run."
			assign_boss_sprite()

func choose_character():
	var complete_postit = ["MomsHeart", "MomsHeartHard", "Isaac", "IsaacHard", "BlueBaby", "BlueBabyHard", "Satan", "SatanHard", "Lamb", "LambHard", "MegaSatan", "MegaSatanHard", "BossRush", "BossRushHard", "Hush", "HushHard", "Mother", "MotherHard", "Beast", "BeastHard", "Delirium", "DeliriumHard", "UltraGreed", "UltraGreedier"]
	var unlocked_characters = Global.get_unlocked_characters()
	var final_characters = []
	if Global.load_value_from_save("RollSettings", "Include normal characters in pool") == true:
		for character in unlocked_characters:
			if not character.contains("Tainted"):
				if Global.load_value_from_save("Miscellaneous", "5NightsAtMoms") == false and not true_random and not ultra_random:
					var streak_characters = Global.load_value_from_save("5NAM", "5NAMStreakCharacters", [])
					if streak_characters.find(character) == -1: final_characters.append(character)
	if Global.load_value_from_save("RollSettings", "Include tainted characters in pool") == true:
		for character in unlocked_characters:
			if character.contains("Tainted"):
				if Global.load_value_from_save("Miscellaneous", "5NightsAtMoms") == false and not true_random and not ultra_random:
					var streak_characters = Global.load_value_from_save("5NAM", "5NAMStreakCharacters", [])
					if streak_characters.find(character) == -1: final_characters.append(character)
	#if Global.load_value_from_save("Miscellaneous", "5NightsAtMoms") == false:
		#var streak_characters = Global.load_value_from_save("5NAM", "5NAMStreakCharacters", [])
		#for character in unlocked_characters:
			#if streak_characters.find(character) == -1: final_characters.append(character)
	if final_characters.size() == 0: final_characters = unlocked_characters
	if true_random or ultra_random:
		var rand = randi() % unlocked_characters.size()
		selected_character = unlocked_characters[rand]
		assign_character_sprite()
		return
	var pool = []
	for character in final_characters:
		var postit = Global.get_remaining_marks_for_character(character)
		if postit.size() > 0:
			pool.append(character)
	var rand = randi() % pool.size()
	selected_character = pool[rand]
	$"%PlayerName".text = selected_character
	assign_character_sprite()

func assign_character_sprite():
	match selected_character:
		"Isaac": $"%Player".texture = character_isaac
		"Magdalene": $"%Player".texture = character_magdalene
		"Cain": $"%Player".texture = character_cain
		"Judas": $"%Player".texture = character_judas
		"???": $"%Player".texture = character_bluebaby
		"Eve": $"%Player".texture = character_eve
		"Samson": $"%Player".texture = character_samson
		"Eden": $"%Player".texture = character_eden
		"Azazel": $"%Player".texture = character_azazel
		"Lazarus": $"%Player".texture = character_lazarus
		"The Lost": $"%Player".texture = character_lost
		"Lilith": $"%Player".texture = character_lilith
		"Keeper": $"%Player".texture = character_keeper
		"Apollyon": $"%Player".texture = character_apollyon
		"The Forgotten": $"%Player".texture = character_forgotten
		"Bethany": $"%Player".texture = character_bethany
		"Jacob & Esau": $"%Player".texture = character_jacobesau
		"Tainted Isaac": $"%Player".texture = character_t_isaac
		"Tainted Magdalene": $"%Player".texture = character_t_magdalene
		"Tainted Cain": $"%Player".texture = character_t_cain
		"Tainted Judas": $"%Player".texture = character_t_judas
		"Tainted ???": $"%Player".texture = character_t_bluebaby
		"Tainted Eve": $"%Player".texture = character_t_eve
		"Tainted Samson": $"%Player".texture = character_t_samson
		"Tainted Eden": $"%Player".texture = character_t_eden
		"Tainted Azazel": $"%Player".texture = character_t_azazel
		"Tainted Lazarus": $"%Player".texture = character_t_lazarus
		"Tainted Lost": $"%Player".texture = character_t_lost
		"Tainted Lilith": $"%Player".texture = character_t_lilith
		"Tainted Keeper": $"%Player".texture = character_t_keeper
		"Tainted Apollyon": $"%Player".texture = character_t_apollyon
		"Tainted Forgotten": $"%Player".texture = character_t_forgotten
		"Tainted Bethany": $"%Player".texture = character_t_bethany
		"Tainted Jacob": $"%Player".texture = character_t_jacob
	$"%PlayerName".text = selected_character

func choose_boss():
	var unlocked_bosses = Global.get_unlocked_bosses()
	if true_random or ultra_random:
		var rand = randi() % unlocked_bosses.size()
		selected_boss = unlocked_bosses[rand]
		$"%BossName".text = selected_boss
		assign_boss_sprite()
		return
	if beaten_mom == false:
		var rand = randi_range(0, 1)
		match rand:
			0:
				selected_boss = "Mom"
			1:
				selected_boss = "UltraGreed"
		assign_boss_sprite()
		return
	var postit = Global.get_remaining_marks_for_character(selected_character)
	var trimmed = []
	for mark in postit:
		if not mark.contains("Hard") and unlocked_bosses.find(mark) != -1:
			if Global.load_value_from_save("RollSettings", "Include Boss Rush & Hush as primary objectives") == false and (mark.contains("BossRush") or mark.contains("Hush")): continue
			trimmed.append(mark)
	if trimmed.size() == 0:
		trimmed = ["BlueBaby", "Lamb", "MegaSatan", "Mother", "Beast", "Delirium", "UltraGreedier"]
		if Global.load_value_from_save("RollSettings", "Include Boss Rush & Hush as primary objectives") == true:
			trimmed.append("BossRush")
			trimmed.append("Hush")
	var rand = randi() % trimmed.size()
	selected_boss = trimmed[rand]
	$"%BossName".text = selected_boss
	assign_boss_sprite()

func assign_boss_sprite():
	match selected_boss:
		"Mom": 
			$"%Boss".texture = boss_mom
			$"%BossName".text = "Mom"
		"MomsHeart": 
			$"%Boss".texture = boss_momsheart
			$"%BossName".text = "Mom's Heart"
		"Isaac": 
			$"%Boss".texture = boss_isaac
			$"%BossName".text = "Isaac"
		"BlueBaby": 
			$"%Boss".texture = boss_bluebaby
			$"%BossName".text = "???"
		"Satan": 
			$"%Boss".texture = boss_satan
			$"%BossName".text = "Satan"
		"Lamb": 
			$"%Boss".texture = boss_lamb
			$"%BossName".text = "The Lamb"
		"MegaSatan": 
			$"%Boss".texture = boss_megasatan
			$"%BossName".text = "Mega Satan"
		"BossRush": 
			$"%Boss".texture = boss_bossrush
			$"%BossName".text = "Boss Rush"
		"Hush": 
			$"%Boss".texture = boss_hush
			$"%BossName".text = "Hush"
		"Mother": 
			$"%Boss".texture = boss_mother
			$"%BossName".text = "Mother"
		"Beast": 
			$"%Boss".texture = boss_beast
			$"%BossName".text = "Beast"
		"Delirium": 
			$"%Boss".texture = boss_delirium
			$"%BossName".text = "Delirium"
		"UltraGreed": 
			$"%Boss".texture = boss_ultragreed
			$"%BossName".text = "Ultra Greed"
		"UltraGreedier": 
			$"%Boss".texture = boss_ultragreedier
			$"%BossName".text = "Ultra Greedier"

func choose_challenge():
	var rand = randi() % incomplete_challenges.size()
	doing_challenge = incomplete_challenges[rand]
	$"%AchievementLabel".show()
	$"%ChallengeDesc".hide()
	$"%ChallengeName".text = doing_challenge
	match doing_challenge:
		"Pitch Black":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"High Brow":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Head Trauma":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Darkness Falls":
			selected_character = "Eve"
			selected_boss = "Satan"
			assign_character_sprite()
			assign_boss_sprite()
		"The Tank":
			selected_character = "Magdalene"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Solar System":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"Suicide King":
			selected_character = "Lazarus"
			selected_boss = "Isaac"
			assign_character_sprite()
			assign_boss_sprite()
		"Cat Got Your Tongue?":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Demo Man":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"Cursed!":
			selected_character = "Magdalene"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Glass Cannon":
			selected_character = "Judas"
			selected_boss = "Satan"
			assign_character_sprite()
			assign_boss_sprite()
		"When Life Gives You Lemons":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"BEANS!":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"It's In The Cards":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Slow Roll":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Computer Savvy":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Waka Waka":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"The Host":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"The Family Man":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Purist":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"XXXXXXXXL":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"SPEED!":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"Blue Bomber":
			selected_character = "???"
			selected_boss = "Satan"
			assign_character_sprite()
			assign_boss_sprite()
		"PAY TO PLAY":
			selected_character = "Isaac"
			selected_boss = "Isaac"
			assign_character_sprite()
			assign_boss_sprite()
		"Have A Heart":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"I RULE!":
			selected_character = "Isaac"
			selected_boss = "MegaSatan"
			assign_character_sprite()
			assign_boss_sprite()
		"BRAINS!":
			selected_character = "???"
			selected_boss = "BlueBaby"
			assign_character_sprite()
			assign_boss_sprite()
		"PRIDE DAY!":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"Onan's Streak":
			selected_character = "Judas"
			selected_boss = "Isaac"
			assign_character_sprite()
			assign_boss_sprite()
		"The Guardian":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"Backasswards":
			selected_character = "Isaac"
			selected_boss = "MegaSatan"
			assign_character_sprite()
			assign_boss_sprite()
		"April's Fool":
			selected_character = "Isaac"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"Pokey Mans":
			selected_character = "Isaac"
			selected_boss = "Isaac"
			assign_character_sprite()
			assign_boss_sprite()
		"Ultra Hard":
			selected_character = "Isaac"
			selected_boss = "MegaSatan"
			assign_character_sprite()
			assign_boss_sprite()
		"Pong":
			selected_character = "Isaac"
			selected_boss = "BlueBaby"
			assign_character_sprite()
			assign_boss_sprite()
		"Scat Man":
			selected_character = "Isaac"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Bloody Mary":
			selected_character = "Bethany"
			selected_boss = "Satan"
			assign_character_sprite()
			assign_boss_sprite()
		"Baptism By Fire":
			selected_character = "Bethany"
			selected_boss = "Isaac"
			assign_character_sprite()
			assign_boss_sprite()
		"Isaac's Awakening":
			selected_character = "Isaac"
			selected_boss = "Mother"
			assign_character_sprite()
			assign_boss_sprite()
		"Seeing Double":
			selected_character = "Jacob & Esau"
			selected_boss = "MomsHeart"
			assign_character_sprite()
			assign_boss_sprite()
		"Pica Run":
			selected_character = "Isaac"
			selected_boss = "Isaac"
			assign_character_sprite()
			assign_boss_sprite()
		"Hot Potato":
			selected_character = "Tainted Forgotten"
			selected_boss = "Satan"
			assign_character_sprite()
			assign_boss_sprite()
		"Cantripped!":
			selected_character = "Tainted Cain"
			selected_boss = "Mom"
			assign_character_sprite()
			assign_boss_sprite()
		"Red Redemption":
			selected_character = "Tainted Jacob"
			selected_boss = "Mother"
			assign_character_sprite()
			assign_boss_sprite()
		"DELETE THIS":
			selected_character = "Isaac"
			selected_boss = "BlueBaby"
			assign_character_sprite()
			assign_boss_sprite()

func _on_return_pressed() -> void:
	$"%LoadingRect".modulate.a = 0
	loading_out = true

func _on_reroll_pressed() -> void:
	get_tree().reload_current_scene()
