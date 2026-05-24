extends ItemList

const VANILLA_CHALLENGES = [
	"Pitch Black",
	"High Brow",
	"Head Trauma",
	"Darkness Falls",
	"The Tank",
	"Solar System",
	"Suicide King",
	"Cat Got Your Tongue?",
	"Demo Man",
	"Cursed!",
	"Glass Cannon",
	"When Life Gives You Lemons",
	"BEANS!",
	"It's In The Cards",
	"Slow Roll",
	"Computer Savvy",
	"Waka Waka",
	"The Host",
	"The Family Man",
	"Purist",
	"XXXXXXXXL",
	"SPEED!",
	"Blue Bomber",
	"PAY TO PLAY",
	"Have A Heart",
	"I RULE!",
	"BRAINS!",
	"PRIDE DAY!",
	"Onan's Streak",
	"The Guardian",
	"Backasswards",
	"April's Fool",
	"Pokey Mans",
	"Ultra Hard",
	"Pong",
	"Scat Man",
	"Bloody Mary",
	"Baptism By Fire",
	"Isaac's Awakening",
	"Seeing Double",
	"Pica Run",
	"Hot Potato",
	"Cantripped!",
	"Red Redemption",
	"DELETE THIS"
]

var time = 0
var active = false

func _ready() -> void:
	set_challenges()

func _process(delta: float) -> void:
	if active:
		time += delta
	else:
		pass
	if time >= 0.5:
		set_challenges()
		time = 0.0

func set_challenges():
	var keys = Global.save.get_section_keys("Challenges")
	for index in range(item_count):
		match index % 3:
			0:
				set_item_selectable(index, false)
				set_item_disabled(index, true)
				deselect(index)
			1:
				set_item_selectable(index, true)
				set_item_disabled(index, false)
				deselect(index)
			2:
				set_item_selectable(index, true)
				set_item_disabled(index, true)
				deselect(index)
	for key in keys:
		if VANILLA_CHALLENGES.find(key) == -1: continue
		var outer_break = false
		var value = Global.load_value_from_save("Challenges", key)
		for index in range(item_count):
			if index % 3 != 0: continue
			if value is Array:
				if get_item_text(index) == key:
					if value[0] == true: 
						select(index + 1, false)
						set_item_disabled(index + 2, false)
						outer_break = true
					if value[1] == true:
						select(index + 2, false)
						outer_break = true
					if outer_break == true:
						break
	# now do custom challenges
	for custom in Custom.custom_challenges:
		var already_found = false
		var outer_break = false
		var value = Global.load_value_from_save("Challenges", custom["name"], [true, false])
		for index in range(item_count):
			if index % 3 != 0: continue
			if value is Array:
				if get_item_text(index) == custom["name"]:
					already_found = true
					if value[0] == true: 
						select(index + 1, false)
						set_item_disabled(index + 2, false)
						outer_break = true
					if value[1] == true:
						select(index + 2, false)
						outer_break = true
					if outer_break == true:
						break
		if already_found: continue
		if value is Array:
						var k = add_item(custom["name"], null, false)
						var i = add_item("(Unlocked?)")
						var j = add_item("(Beaten?)")
						set_item_disabled(j, true)
						if value[0] == true:
							select(i, false)
							set_item_disabled(j, false)
							outer_break = true
						if value[1] == true:
							select(j, false)
							outer_break = true
						if outer_break == true:
							continue
			#for index in range(item_count):
				#if index % 3 != 0: continue
				#if value is Array:
					#if get_item_text(index) == key:
						#if value[0] == true: 
							#select(index + 1, false)
							#set_item_disabled(index + 2, false)
							#outer_break = true
						#if value[1] == true:
							#select(index + 2, false)
							#outer_break = true
						#if outer_break == true:
							#break

func _on_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	if index % 3 == 1 and selected == false:
		deselect(index + 1)
	for idx in range(item_count):
		if idx % 3 != 0: continue
		Global.save_to_savefile(Global.current_save_file, "Challenges", get_item_text(idx), [is_selected(idx + 1), is_selected(idx + 2)])
