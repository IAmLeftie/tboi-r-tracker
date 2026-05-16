extends ItemList

func _ready() -> void:
	load_unlocked_characters()
	
func load_unlocked_characters():
	for idx in item_count:
		var category_name = "UnlockedCharacters"
		if idx % 2 == 1: category_name = "UnlockedTainted"
		if Global.load_value_from_save(category_name, get_item_text(idx)) == true:
			select(idx, false)

func _on_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	match index % 2:
		#Normal
		0:
			pass
		#Tainted
		1:
			pass
