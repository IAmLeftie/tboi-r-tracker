extends VBoxContainer

var active = true
@onready var text_edit = $TextEdit

func get_value():
	return str(text_edit.text)
	
func set_value(value: String):
	text_edit.text = value

func reset():
	text_edit.text = ""
	active = false

func activate():
	active = true

func _process(delta: float) -> void:
	visible = active
