extends ItemList

func _ready():
	setup_progression()

func setup_progression():
	var keys = Global.save.get_section_keys("Miscellaneous")
	for key in keys:
		match key:
			"BeatenMom":
				if Global.load_value_from_save("Miscellaneous", key) == true:
					select(0, false)
				else:
					deselect(0)
			"5NightsAtMoms":
				if Global.load_value_from_save("Miscellaneous", key) == true:
					select(1, false)
				else:
					deselect(1)
			"Zip":
				if Global.load_value_from_save("Miscellaneous", key) == true:
					select(2, false)
				else:
					deselect(2)
			"ItsTheKey":
				if Global.load_value_from_save("Miscellaneous", key) == true:
					select(3, false)
				else:
					deselect(3)


func _on_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	var key
	match get_item_text(index):
		"Beaten Mom for the first time":
			key = "BeatenMom"
		"\"5 Nights At Mom's\" achieved":
			key = "5NightsAtMoms"
		"\"ZIP!\" achieved":
			key = "Zip"
		"\"It's The Key\" achieved":
			key = "ItsTheKey"
			
	Global.save_to_savefile(Global.current_save_file, "Miscellaneous", key, selected)


func _on_nam_reset_pressed() -> void:
	Global.save_to_savefile(Global.current_save_file, "5NAM", "Current5NAMStreak", 0)
	Global.save_to_savefile(Global.current_save_file, "5NAM", "5NAMStreakCharacters", [])
	Global.create_popup(636, 645, "Your 5 Nights at Mom's streak has been reset.")
