extends Node2D

onready var game_music = $GameMusic

func _ready():
	Settings.connect("settings_changed", self, "_on_settings_changed")
	if Settings.play_music:
		game_music.play()

func play():
	game_music.play()

func stop():
	game_music.stop()

func _on_settings_changed():
	game_music.playing = Settings.play_music
