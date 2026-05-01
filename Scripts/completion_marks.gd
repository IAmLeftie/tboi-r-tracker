extends Control

var current_character = "Isaac"

var time = 0

@onready var postit = $"Postit"
@onready var unlock_list = $UnlockList
@onready var normal_postit_texture = preload("res://Assets/sprites/post-it/normal-postit.png")
@onready var normal_delirium_postit_texture = preload("res://Assets/sprites/post-it/normal-delirium-postit.png")
@onready var normal_delirium_hard_postit_texture = preload("res://Assets/sprites/post-it/normal-hard-delirium-postit.png")
@onready var tainted_postit_texture = preload("res://Assets/sprites/post-it/tainted-postit.png")
@onready var tainted_delirium_postit_texture = preload("res://Assets/sprites/post-it/tainted-delirium-postit.png")
@onready var tainted_delirium_hard_postit_texture = preload("res://Assets/sprites/post-it/tainted-hard-delirium-postit.png")
@onready var moms_heart_mark = $"Postit/MomsHeart"
@onready var hard_moms_heart_mark = $"Postit/MomsHeart/Hard"
@onready var isaac_mark = $"Postit/Isaac"
@onready var hard_isaac_mark = $"Postit/Isaac/Hard"
@onready var bluebaby_mark = $"Postit/BlueBaby"
@onready var hard_bluebaby_mark = $"Postit/BlueBaby/Hard"
@onready var satan_mark = $"Postit/Satan"
@onready var hard_satan_mark = $"Postit/Satan/Hard"
@onready var lamb_mark = $"Postit/Lamb"
@onready var hard_lamb_mark = $"Postit/Lamb/Hard"
@onready var greed_mark = $"Postit/UltraGreed"
@onready var hard_greed_mark = $"Postit/UltraGreed/Hard"
@onready var mega_satan_mark = $"Postit/MegaSatan"
@onready var hard_mega_satan_mark = $"Postit/MegaSatan/Hard"
@onready var boss_rush_mark = $"Postit/BossRush"
@onready var hard_boss_rush_mark = $"Postit/BossRush/Hard"
@onready var hush_mark = $"Postit/Hush"
@onready var hard_hush_mark = $"Postit/Hush/Hard"
@onready var mother_mark = $"Postit/Mother"
@onready var hard_mother_mark = $"Postit/Mother/Hard"
@onready var beast_mark = $"Postit/Beast"
@onready var hard_beast_mark = $"Postit/Beast/Hard"

func _ready() -> void:
	set_postit("Isaac")

func set_postit(name: String):
	
	var category_name = "CharacterMarks"
	if name.contains("Tainted"): category_name = "TaintedMarks"
	match category_name:
		"CharacterMarks":
			postit.texture = normal_postit_texture
		"TaintedMarks":
			postit.texture = tainted_postit_texture
	var data = Global.save.get_value(category_name, name)
	moms_heart_mark.hide()
	hard_moms_heart_mark.hide()
	isaac_mark.hide()
	hard_isaac_mark.hide()
	bluebaby_mark.hide()
	hard_bluebaby_mark.hide()
	satan_mark.hide()
	hard_satan_mark.hide()
	lamb_mark.hide()
	hard_lamb_mark.hide()
	greed_mark.hide()
	hard_greed_mark.hide()
	mega_satan_mark.hide()
	hard_mega_satan_mark.hide()
	boss_rush_mark.hide()
	hard_boss_rush_mark.hide()
	hush_mark.hide()
	hard_hush_mark.hide()
	mother_mark.hide()
	hard_mother_mark.hide()
	beast_mark.hide()
	hard_beast_mark.hide()
	unlock_list.deselect_all()
	for index in range(unlock_list.item_count):
		if index % 2 == 1:
			unlock_list.set_item_disabled(index, true)
	if data is Array:
		for d in data:
			match d:
				"MomsHeart":
					moms_heart_mark.show()
					unlock_list.select(0, false)
					unlock_list.set_item_disabled(1, false)
				"MomsHeartHard":
					hard_moms_heart_mark.show()
					unlock_list.select(1, false)
				"Isaac":
					isaac_mark.show()
					unlock_list.select(2, false)
					unlock_list.set_item_disabled(3, false)
				"IsaacHard":
					hard_isaac_mark.show()
					unlock_list.select(3, false)
				"BlueBaby":
					bluebaby_mark.show()
					unlock_list.select(4, false)
					unlock_list.set_item_disabled(5, false)
				"BlueBabyHard":
					hard_bluebaby_mark.show()
					unlock_list.select(5, false)
				"Satan":
					satan_mark.show()
					unlock_list.select(6, false)
					unlock_list.set_item_disabled(7, false)
				"SatanHard":
					hard_satan_mark.show()
					unlock_list.select(7, false)
				"Lamb":
					lamb_mark.show()
					unlock_list.select(8, false)
					unlock_list.set_item_disabled(9, false)
				"LambHard":
					hard_lamb_mark.show()
					unlock_list.select(9, false)
				"UltraGreed":
					greed_mark.show()
					unlock_list.select(22, false)
					unlock_list.set_item_disabled(23, false)
				"UltraGreedier":
					hard_greed_mark.show()
					unlock_list.select(23, false)
				"MegaSatan":
					mega_satan_mark.show()
					unlock_list.select(10, false)
					unlock_list.set_item_disabled(11, false)
				"MegaSatanHard":
					hard_mega_satan_mark.show()
					unlock_list.select(11, false)
				"BossRush":
					boss_rush_mark.show()
					unlock_list.select(12, false)
					unlock_list.set_item_disabled(13, false)
				"BossRushHard":
					hard_boss_rush_mark.show()
					unlock_list.select(13, false)
				"Hush":
					hush_mark.show()
					unlock_list.select(14, false)
					unlock_list.set_item_disabled(15, false)
				"HushHard":
					hard_hush_mark.show()
					unlock_list.select(15, false)
				"Mother":
					mother_mark.show()
					unlock_list.select(16, false)
					unlock_list.set_item_disabled(17, false)
				"MotherHard":
					hard_mother_mark.show()
					unlock_list.select(17, false)
				"Beast":
					beast_mark.show()
					unlock_list.select(18, false)
					unlock_list.set_item_disabled(19, false)
				"BeastHard":
					hard_beast_mark.show()
					unlock_list.select(19, false)
				"Delirium":
					unlock_list.select(20, false)
					unlock_list.set_item_disabled(21, false)
					match category_name:
						"CharacterMarks":
							postit.texture = normal_delirium_postit_texture
						"TaintedMarks":
							postit.texture = tainted_delirium_postit_texture
				"DeliriumHard":
					unlock_list.select(21, false)
					match category_name:
						"CharacterMarks":
							postit.texture = normal_delirium_hard_postit_texture
						"TaintedMarks":
							postit.texture = tainted_delirium_hard_postit_texture

func _on_previous_pressed() -> void:
	var data = Global.get_unlocked_characters()
	if data is Array:
		var index = data.find(current_character)
		if index != -1:
			current_character = data[(index - 1) % data.size()]
			$"%ActiveCharacter".text = current_character
			set_postit(current_character)
		
func _on_next_pressed() -> void:
	var data = Global.get_unlocked_characters()
	if data is Array:
		var index = data.find(current_character)
		if index != -1:
			current_character = data[(index + 1) % data.size()]
			$"%ActiveCharacter".text = current_character
			set_postit(current_character)

func get_mark_name_from_index(index: int):
	match index:
		0:
			return "MomsHeart"
		1:
			return "MomsHeartHard"
		2:
			return "Isaac"
		3:
			return "IsaacHard"
		4:
			return "BlueBaby"
		5:
			return "BlueBabyHard"
		6:
			return "Satan"
		7:
			return "SatanHard"
		8:
			return "Lamb"
		9:
			return "LambHard"
		10:
			return "MegaSatan"
		11:
			return "MegaSatanHard"
		12:
			return "BossRush"
		13:
			return "BossRushHard"
		14:
			return "Hush"
		15:
			return "HushHard"
		16:
			return "Mother"
		17:
			return "MotherHard"
		18:
			return "Beast"
		19:
			return "BeastHard"
		20:
			return "Delirium"
		21:
			return "DeliriumHard"
		22:
			return "UltraGreed"
		23:
			return "UltraGreedier"
			
func get_mark_index_from_name(name: String) -> int:
	match name:
		"MomsHeart":
			return 0
		"MomsHeartHard":
			return 1
		"Isaac":
			return 2
		"IsaacHard":
			return 3
		"BlueBaby":
			return 4
		"BlueBabyHard":
			return 5
		"Satan":
			return 6
		"SatanHard":
			return 7
		"Lamb":
			return 8
		"LambHard":
			return 9
		"MegaSatan":
			return 10
		"MegaSatanHard":
			return 11
		"BossRush":
			return 12
		"BossRushHard":
			return 13
		"Hush":
			return 14
		"HushHard":
			return 15
		"Mother":
			return 16
		"MotherHard":
			return 17
		"Beast":
			return 18
		"BeastHard":
			return 19
		"Delirium":
			return 20
		"DeliriumHard":
			return 21
		"UltraGreed":
			return 22
		"UltraGreedier":
			return 23
	return -1  # fallback if name not found

func _process(delta: float) -> void:
	time += delta
	if time >= 0.5:
		set_postit(current_character)
		time = 0.0

func _on_unlock_list_multi_selected(index: int, selected: bool) -> void:
		$"%Click2".play()
		if index % 2 == 0 and selected == false:
			unlock_list.deselect(index + 1)
			unlock_list.set_item_disabled(index + 1, true)
		var data = unlock_list.get_selected_items()
		var formatted = []
		for idx in data:
			formatted.append(get_mark_name_from_index(idx))
		match current_character.contains("Tainted"):
			#Normal
			false:
				Global.save_to_savefile(Global.current_save_file, "CharacterMarks", current_character, formatted)
			#Tainted
			true:
				Global.save_to_savefile(Global.current_save_file, "TaintedMarks", current_character, formatted)
