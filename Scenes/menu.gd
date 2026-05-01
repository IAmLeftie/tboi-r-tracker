extends Node2D

var loading = false
var mute = false
var loading_to_roll = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.load_save_file(Global.current_save_file)
	$"%LoadingRect".modulate.a = 1

func _physics_process(delta: float) -> void:
	if loading_to_roll:
		$"%LoadingRect".modulate.a += delta
		$"%Intro".volume_linear -= delta / 2
		$"%Loop".volume_linear -= delta / 2
		if $"%LoadingRect".modulate.a >= 2:
			get_tree().change_scene_to_file("res://Scenes/roll.tscn")
	elif not loading:
		$"%LoadingRect".modulate.a -= delta
		if mute:
			$"%Intro".volume_linear = 0
			$"%Loop".volume_linear = 0
		else:
			$"%Intro".volume_linear = Global.music_volume
			$"%Loop".volume_linear = Global.music_volume
		$"%Click".volume_linear = Global.sfx_volume
		$"%Paper".volume_linear = Global.sfx_volume
		$"%Click2".volume_linear = Global.sfx_volume
		$"%Dice".volume_linear = Global.sfx_volume
	else:
		$"%LoadingRect".modulate.a += delta
		$"%Intro".volume_linear -= delta / 2
		$"%Loop".volume_linear -= delta / 2
		if $"%LoadingRect".modulate.a >= 2:
			get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_main_menu_pressed() -> void:
	loading = true
	$"%LoadingRect".modulate.a = 0

func _on_mute_toggled(toggled_on: bool) -> void:
	mute = toggled_on
	$"%Click2".play()

func _on_characters_toggled(toggled_on: bool) -> void:
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".show()
	$"%BossesContainer".hide()
	$"%ChallengesContainer".hide()
	$"%MiscContainer".hide()
	$"%RollSettingsContainer".hide()
	$AnimationPlayer.play("RESET")


func _on_bosses_toggled(toggled_on: bool) -> void:
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".hide()
	$"%BossesContainer".show()
	$"%ChallengesContainer".hide()
	$"%MiscContainer".hide()
	$"%RollSettingsContainer".hide()
	$AnimationPlayer.play("RESET")

func _on_challenges_toggled(toggled_on: bool) -> void:
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".hide()
	$"%BossesContainer".hide()
	$"%ChallengesContainer".show()
	$"%MiscContainer".hide()
	$"%RollSettingsContainer".hide()
	$AnimationPlayer.play("RESET")

func _on_misc_toggled(toggled_on: bool) -> void:
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".hide()
	$"%BossesContainer".hide()
	$"%ChallengesContainer".hide()
	$"%MiscContainer".show()
	$"%RollSettingsContainer".hide()
	$AnimationPlayer.play("RESET")

func _on_roll_toggled(toggled_on: bool) -> void:
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".hide()
	$"%BossesContainer".hide()
	$"%ChallengesContainer".hide()
	$"%MiscContainer".hide()
	$"%RollSettingsContainer".show()
	$AnimationPlayer.play("DiceFall")
	
func _on_characters_container_tab_clicked(tab: int) -> void:
	$"%Click".play()

func _on_bosses_container_tab_clicked(tab: int) -> void:
	$"%Click".play()


func _on_dice_pressed() -> void:
	loading_to_roll = true
	$"%LoadingRect".modulate.a = 0
