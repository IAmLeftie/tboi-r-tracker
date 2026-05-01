extends ItemList

func _ready() -> void:
	load_unlocked_characters()
	
func load_unlocked_characters():
	for idx in item_count:
		var category_name = "UnlockedCharacters"
		if idx % 2 == 1: category_name = "UnlockedTainted"
		if Global.save.get_value(category_name, get_item_text(idx)) == true:
			select(idx, false)

func _on_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	match index % 2:
		#Normal
		0:
			Global.save_to_savefile(Global.current_save_file, "UnlockedCharacters", get_item_text(index), selected)
		#Tainted
		1:
			Global.save_to_savefile(Global.current_save_file, "UnlockedTainted", get_item_text(index), selected)
