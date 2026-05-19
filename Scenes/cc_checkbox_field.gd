extends HBoxContainer

var active = true
@onready var checkbox = $Checkbox

func get_value():
	return str(checkbox.button_pressed)

func set_value(value):
	if value is String:
		match value:
			"true":
				value = true
			"false":
				value = false
	checkbox.button_pressed = value

func reset():
	checkbox.set_pressed_no_signal(false)
	active = false
	
func activate():
	active = true

func _process(delta: float) -> void:
	visible = active
