extends ItemList

func _ready():
	setup_progression()

func setup_progression():
	var keys = Global.save.get_section_keys("Miscellaneous")
	for key in keys:
		match key:
			"BeatenMom":
				if Global.save.get_value("Miscellaneous", key) == true:
					select(0, false)
				else:
					deselect(0)
			"5NightsAtMoms":
				if Global.save.get_value("Miscellaneous", key) == true:
					select(1, false)
				else:
					deselect(1)
			"Zip":
				if Global.save.get_value("Miscellaneous", key) == true:
					select(2, false)
				else:
					deselect(2)
			"ItsTheKey":
				if Global.save.get_value("Miscellaneous", key) == true:
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
