extends Node

signal settings_changed

var play_music := true setget set_play_music
var config = ConfigFile.new()

func _ready():
	var err = config.load("user://settings.cfg")
	if err == OK: # If not, something went wrong with the file loading
		# load settings from file
		play_music = config.get_value("audio", "play_music", play_music)

func set_play_music(value: bool):
	if play_music != value:
		play_music = value
		config.set_value("audio", "play_music", play_music)
		_save()
		emit_signal("settings_changed")

func _save():
	# Save the changes by overwriting the previous file
	config.save("user://settings.cfg")
