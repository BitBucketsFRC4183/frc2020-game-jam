extends Node

signal settings_changed

var play_music := true setget set_play_music
var server_port := 3000 setget set_server_port
var client_host := "127.0.0.1" setget set_client_host
var client_port := 3000 setget set_client_port

var config = ConfigFile.new()

func _ready():
	var err = config.load("user://settings.cfg")
	if err == OK: # If not, something went wrong with the file loading
		# load settings from file
		play_music = config.get_value("audio", "play_music", play_music)
		client_host = config.get_value("network", "client_host", client_host)
		client_port = config.get_value("network", "client_port", client_port)
		server_port = config.get_value("network", "server_port", server_port)

func set_play_music(value: bool):
	if play_music != value:
		play_music = value
		config.set_value("audio", "play_music", play_music)
		_save()

func set_server_port(value: int):
	if server_port != value:
		server_port = value
		config.set_value("network", "server_port", server_port)
		_save()

func set_client_host(value: String):
	if client_host != value:
		client_host = value
		config.set_value("network", "client_host", client_host)
		_save()

func set_client_port(value: int):
	if client_port != value:
		client_port = value
		config.set_value("network", "client_port", client_port)
		_save()

func _save():
	# Save the changes by overwriting the previous file
	config.save("user://settings.cfg")
	emit_signal("settings_changed")
