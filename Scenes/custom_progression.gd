extends ItemList

func _ready():
	setup_progression()

func setup_progression():
	for custom in Custom.custom_niche:
		var i = add_item(custom["name"])
		if Global.load_value_from_save("Miscellaneous", custom["name"], false) == true:
			select(i, false)
		else:
			deselect(i)

func _on_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	var key = get_item_text(index)
	Global.save_to_savefile(Global.current_save_file, "Miscellaneous", key, selected)
