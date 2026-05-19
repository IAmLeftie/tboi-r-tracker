extends HBoxContainer

var active = true
@onready var line_edit = $LineEdit

func get_value():
	return line_edit.text
	
func set_value(value):
	line_edit.text = value

func reset():
	line_edit.text = ""
	active = false

func activate():
	active = true

func _process(delta: float) -> void:
	visible = active
