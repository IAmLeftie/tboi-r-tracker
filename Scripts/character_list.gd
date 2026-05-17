extends ItemList

func _ready() -> void:
	load_custom_characters()
	load_unlocked_characters()
	
func load_unlocked_characters():
	for idx in item_count:
		var category_name = "UnlockedCharacters"
		if idx % 2 == 1: category_name = "UnlockedTainted"
		if Global.load_value_from_save(category_name, get_item_text(idx)) == true:
			select(idx, false)
			
func load_custom_characters():
	for custom in Custom.custom_characters:
		if custom["name"] == "__DUMMY":
			add_item("", null, false)
		else:
			add_item(custom["name"], custom["small_sprite"])

func _on_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	match index % 2:
		#Normal
		0:
			Global.save_to_savefile(Global.current_save_file, "UnlockedCharacters", get_item_text(index), selected)
		#Tainted
		1:
			Global.save_to_savefile(Global.current_save_file, "UnlockedTainted", get_item_text(index), selected)
