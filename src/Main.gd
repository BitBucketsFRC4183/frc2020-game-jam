extends MarginContainer

func _ready():
	Signals.connect("pre_start_game", self, "_on_pre_start_game")
	Signals.connect("server_disconnected", self, "_on_server_disconnected")

# on exit, quit (obviously)
func _on_Exit_pressed():
	get_tree().quit()


func _on_Host_Game_pressed():
	Network.host_game("Player 1")
	Network.server.begin_game()

	get_tree().change_scene("res://src/World.tscn")

func _on_Join_Game_pressed():
	Network.join_game("127.0.0.1", "Player 2")

	get_tree().change_scene("res://src/World.tscn")


func _on_pre_start_game():
	# tell the server we are ready
	RPC.send_ready_to_start()


func _on_server_disconnected():
	print("Server kicked us out!")
	get_tree().change_scene("res://src/Main.tscn")
