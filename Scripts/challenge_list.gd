extends ItemList

var time = 0

func _ready() -> void:
	set_challenges()

func _process(delta: float) -> void:
	time += delta
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
		var outer_break = false
		var value = Global.save.get_value("Challenges", key)
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

func _on_multi_selected(index: int, selected: bool) -> void:
	$"%Click2".play()
	if index % 3 == 1 and selected == false:
		deselect(index + 1)
	for idx in range(item_count):
		if idx % 3 != 0: continue
		Global.save_to_savefile(Global.current_save_file, "Challenges", get_item_text(idx), [is_selected(idx + 1), is_selected(idx + 2)])
