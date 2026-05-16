extends ItemList

func _ready() -> void:
	load_unlocked_bosses()
	
func load_unlocked_bosses():
	for idx in item_count:
		var category_name = "UnlockedBosses"
		if Global.load_value_from_save(category_name, get_item_text(idx)) == true:
			select(idx, false)

func _on_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	Global.save_to_savefile(Global.current_save_file, "UnlockedBosses", get_item_text(index), selected)
