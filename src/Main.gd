extends Control

# true if we are currently joining a game, waiting for the server to give us data
var joining = false setget set_joining

func _ready():
	Signals.connect("player_data_updated", self, "_on_player_data_updated")
	Signals.connect("server_disconnected", self, "_on_server_disconnected")
	Signals.connect("connection_to_server_failed", self, "_on_connection_to_server_failed")
	
	$HostWindow/VBoxContainer/HBoxContainer/PortEdit.text = "%s" % Settings.server_port
	$JoinWindow/VBoxContainer/HBoxContainer/PortEdit.text = "%s" % Settings.client_port
	$JoinWindow/VBoxContainer/HBoxContainer/HostEdit.text = Settings.client_host

# on exit, quit (obviously)
func _on_Exit_pressed():
	get_tree().quit()


func _on_HostGameButton_pressed():
	hide()
	$HostWindow.popup_centered()

func _on_JoinGameButton_pressed():
	hide()
	$JoinWindow.popup_centered()


func _on_NewGameButton_pressed():
	Network.host_game(true)
	Server.begin_game(true)
	RPC.send_ready_to_start(true)
	RPC.send_post_start_game()
	get_tree().change_scene("res://src/World.tscn")

func _on_JoinWindow_popup_hide():
	show()

func set_joining(value: bool):
	joining = value


func _on_CancelButton_pressed():
	joining = false
	Network.close_connection()
	$JoinWindow/VBoxContainer/MarginContainer/VBoxContainer/CancelButton.disabled = true
	$JoinWindow/VBoxContainer/MarginContainer/VBoxContainer/JoinButton.text = "Join"


func _on_JoinButton_pressed():
	$JoinWindow/VBoxContainer/MarginContainer/VBoxContainer/CancelButton.disabled = false
	$JoinWindow/VBoxContainer/MarginContainer/VBoxContainer/JoinButton.text = "Joining..."
	var host = $JoinWindow/VBoxContainer/HBoxContainer/HostEdit.text
	var port = $JoinWindow/VBoxContainer/HBoxContainer/PortEdit.text as int
	Settings.client_port = port
	Settings.client_host = host
	joining = true
	Network.join_game(host, port)

func _on_player_data_updated(player: PlayerData):
	# after we join a server, the server sends us the players list
	# check this player for our network id
	if joining && get_tree().has_network_peer() and player.network_id == get_tree().get_network_unique_id():
		get_tree().change_scene("res://src/Screens/Lobby.tscn")

func _on_SettingsButton_pressed():
	get_tree().change_scene("res://src/Screens/Settings.tscn")


func _on_server_disconnected():
	# server kicked us, set joining to false
	joining = false


func _on_connection_to_server_failed():
	# server kicked us, set joining to false
	joining = false


func _on_CancelHostButton_pressed():
	$HostWindow.hide()
	show()


func _on_HostButton_pressed():
	# Update our server port in settings
	Settings.server_port = $HostWindow/VBoxContainer/HBoxContainer/PortEdit.text as int
	Network.host_game(false)
	Server.begin_game(false)
	get_tree().change_scene("res://src/Screens/Lobby.tscn")
