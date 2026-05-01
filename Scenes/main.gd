extends Node2D

@onready var version = $Version
@onready var logo = $Logo
@onready var save_number = $SaveFileSelect/SaveNumber

var save_file_number = 1

var loading = false

var totalTime = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version.text = ProjectSettings.get_setting("application/config/version")
	save_file_number = Global.current_save_file

func _process(delta: float) -> void:
	save_number.text = "SAVE " + str(save_file_number)
	$"%Intro".volume_linear = Global.music_volume
	$"%Loop".volume_linear = Global.music_volume
	$"%Load".volume_linear = Global.music_volume
	$"%Click".volume_linear = Global.sfx_volume
	$"%Paper".volume_linear = Global.sfx_volume

func _physics_process(delta: float) -> void:
	totalTime += delta
	logo.position.y += 0.05 * sin(totalTime)
	if loading:
		$"%LoadingRect".modulate.a += delta

func _on_next_pressed() -> void:
	$"%Click".play()
	save_file_number += 1
	if save_file_number > 3:
		save_file_number = 1
	Global.save_to_settings("Save", "CurrentSave", save_file_number)
	Global.load_save_file(save_file_number)

func _on_previous_pressed() -> void:
	$"%Click".play()
	save_file_number -= 1
	if save_file_number < 1:
		save_file_number = 3
	Global.save_to_settings("Save", "CurrentSave", save_file_number)
	Global.load_save_file(save_file_number)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_start_pressed() -> void:
	$"%Intro".stop()
	$"%Loop".stop()
	$"%Load".play()
	Global.load_save_file(save_file_number)
	loading = true

func _on_load_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
