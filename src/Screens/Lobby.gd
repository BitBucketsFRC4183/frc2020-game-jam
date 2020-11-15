extends Control

onready var chat = $VBoxContainer/HBoxContainer/ChatContainer/Chat
onready var chat_message = $VBoxContainer/HBoxContainer/ChatContainer/ChatMessage

onready var start_game_button = $VBoxContainer/HBoxContainer/PlayerReadyContainer/LobbyButtons/StartButtonContainer/StartGameButton

var is_server := false
func _ready():
	Signals.connect("pre_start_game", self, "_on_pre_start_game")
	Signals.connect("post_start_game", self, "_on_post_start_game")
	Signals.connect("player_message", self, "_on_player_message")
	Signals.connect("player_data_updated", self, "_on_player_data_updated")

	is_server = get_tree().is_network_server()
	if is_server:
		is_server = true
		start_game_button.visible = true
		_check_start_game_button()
		
	# add all our current messages
	for message in PlayersManager.player_messages:
		var player := PlayersManager.get_player(message.num)
		chat.text += "\n%s%s: %s" % ["Host - " if player.num == 1 else "", player.name, message.message]


func _check_start_game_button():
	start_game_button.disabled = not Server.is_ready_to_start()


func _on_player_message(message: PlayerMessage):
	var player := PlayersManager.get_player(message.num)
	chat.text += "\n%s%s: %s" % ["Host - " if player.num == 1 else "", player.name, message.message]
	chat.set_v_scroll(chat.get_line_count())

func _on_ChatMessage_text_entered(new_text):
	RPC.send_message(new_text)
	chat_message.text = ""


func _on_player_data_updated(player: PlayerData):	
	_check_start_game_button()


func _on_pre_start_game(players: Array):
	# tell the server we are ready
	# RPC.send_ready_to_start()
	pass


func _on_post_start_game():
	get_tree().change_scene("res://src/World.tscn")
	
func _on_BackButton_pressed():
	Network.close_connection()
	Server.reset_values()
	PlayersManager.reset_values()
	get_tree().change_scene("res://src/Main.tscn")


func _on_ReadyButton_pressed():
	PlayersManager.whoami().ready = not PlayersManager.whoami().ready
	RPC.send_ready_to_start(PlayersManager.whoami().ready)


func _on_StartGameButton_pressed():
	print("Server: All players ready, starting the game!")
	RPC.send_post_start_game()
