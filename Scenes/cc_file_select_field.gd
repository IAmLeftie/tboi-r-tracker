extends HBoxContainer

var active = true
@onready var field_edit = $FieldEdit
@onready var open_button = $FieldEdit/OpenButton
@onready var file_dialog = $FileDialog

@export var default_filepath: String

func _on_open_button_pressed() -> void:
	file_dialog.current_dir = default_filepath
	file_dialog.popup()

func _on_file_dialog_file_selected(path: String) -> void:
	var split = path.split("/")
	var file = split[split.size() - 1]
	field_edit.text = file

func get_value():
	return str(field_edit.text)
	
func set_value(value: String):
	field_edit.text = value

func reset():
	field_edit.text = ""
	active = false

func activate():
	active = true

func _process(delta: float) -> void:
	visible = active
