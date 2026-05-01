extends Node2D

func _ready() -> void:
	$"%MusicSlider".value = Global.config.get_value("Volume", "Music")
	$"%SFXSlider".value = Global.config.get_value("Volume", "SFX")

func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Global.music_volume = $"%MusicSlider".value
		Global.save_to_settings("Volume", "Music", $"%MusicSlider".value)

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Global.sfx_volume = $"%SFXSlider".value
		Global.save_to_settings("Volume", "SFX", $"%SFXSlider".value)
		$"%Click".play()

func _process(delta: float) -> void:
	$"%Intro".volume_linear = Global.music_volume
	$"%Loop".volume_linear = Global.music_volume
	$"%Click".volume_linear = Global.sfx_volume
	$"%Paper".volume_linear = Global.sfx_volume

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
