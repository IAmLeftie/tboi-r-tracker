extends Node2D

var loading = false
var mute = false
var loading_to_roll = false

var roll_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Notes.init()
	$"%Mute".set_pressed_no_signal(Global.mute)
	mute = $"%Mute".button_pressed
	Global.load_save_file(Global.current_save_file)
	$"%LoadingRect".modulate.a = 1
	$"%CharactersContainer".callv("set_tab_disabled", [2, true])
	$"%CharactersContainer".callv("set_tab_hidden", [2, true])
	$"%BossesContainer".callv("set_tab_disabled", [1, true])
	$"%BossesContainer".callv("set_tab_hidden", [1, true])
	$"%RollSettingsContainer".callv("set_tab_disabled", [1, true])
	$"%RollSettingsContainer".callv("set_tab_hidden", [1, true])

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
	Global.mute = toggled_on
	$"%Click2".play()

func _on_characters_toggled(toggled_on: bool) -> void:
	roll_open = false
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".show()
	$"%BossesContainer".hide()
	$"%ChallengesContainer".hide()
	$"%MiscContainer".hide()
	$"%RollSettingsContainer".hide()
	$AnimationPlayer.play("RESET")
	$"%ChallengeList".active = false
	if $"%CharactersContainer".current_tab == 1: $"%Completion Marks".active = true
	else: $"%Completion Marks".active = false


func _on_bosses_toggled(toggled_on: bool) -> void:
	roll_open = false
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".hide()
	$"%BossesContainer".show()
	$"%ChallengesContainer".hide()
	$"%MiscContainer".hide()
	$"%RollSettingsContainer".hide()
	$AnimationPlayer.play("RESET")
	$"%ChallengeList".active = false
	$"%Completion Marks".active = false

func _on_challenges_toggled(toggled_on: bool) -> void:
	roll_open = false
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".hide()
	$"%BossesContainer".hide()
	$"%ChallengesContainer".show()
	$"%MiscContainer".hide()
	$"%RollSettingsContainer".hide()
	$AnimationPlayer.play("RESET")
	$"%ChallengeList".active = true
	$"%Completion Marks".active = false

func _on_misc_toggled(toggled_on: bool) -> void:
	roll_open = false
	$"%Click".play()
	$"%Welcome".hide()
	$"%CharactersContainer".hide()
	$"%BossesContainer".hide()
	$"%ChallengesContainer".hide()
	$"%MiscContainer".show()
	$"%RollSettingsContainer".hide()
	$AnimationPlayer.play("RESET")
	$"%ChallengeList".active = false
	$"%Completion Marks".active = false

func _on_roll_toggled(toggled_on: bool) -> void:
	$"%Click".play()
	if roll_open == true: return
	else:
		roll_open = true
	$"%Welcome".hide()
	$"%CharactersContainer".hide()
	$"%BossesContainer".hide()
	$"%ChallengesContainer".hide()
	$"%MiscContainer".hide()
	$"%RollSettingsContainer".show()
	$AnimationPlayer.play("DiceFall")
	$"%ChallengeList".active = false
	$"%Completion Marks".active = false
	
func _on_characters_container_tab_clicked(tab: int) -> void:
	$"%Click".play()
	if tab == 1: $"%Completion Marks".active = true
	else: $"%Completion Marks".active = false

func _on_bosses_container_tab_clicked(tab: int) -> void:
	$"%Click".play()
	$"%ChallengeList".active = false
	$"%Completion Marks".active = false

func _on_dice_pressed() -> void:
	loading_to_roll = true
	$"%LoadingRect".modulate.a = 0
