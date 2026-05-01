class_name MusicPlayer extends Node

@onready var intro = $Intro
@onready var loop = $Loop

func _on_intro_finished() -> void:
	loop.play()
