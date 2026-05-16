extends Node2D

var rising_factor = 25

func init(text: String):
	$"%Text".text = text
	$"%Text".custom_minimum_size.x = clamp($"%Text".get_total_character_count() * 10, 0, 500)
	$"%Text".set_anchors_preset(Control.PRESET_CENTER)
	#$"%Text".custom_minimum_size.x = clamp($"%Text".get_total_character_count() * 15, 0, 500)
	#$"%Text".custom_minimum_size.y = $"%Text".get_line_count() * 26

func _physics_process(delta: float) -> void:
	$"%Text".position.y -= delta * rising_factor
	rising_factor -= delta * 5

func _on_animation_finished(anim_name: StringName) -> void:
	queue_free()
