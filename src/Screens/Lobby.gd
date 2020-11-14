extends Control


func _ready():
	Signals.connect("pre_start_game", self, "_on_pre_start_game")
	Signals.connect("post_start_game", self, "_on_post_start_game")

	if get_tree().is_network_server():
		# START IT UP
		Server.begin_game(false)


func _on_pre_start_game(players: Array):
	# tell the server we are ready
	RPC.send_ready_to_start()


func _on_post_start_game():
	get_tree().change_scene("res://src/World.tscn")
	
func _on_BackButton_pressed():
	Network.close_connection()
	get_tree().change_scene("res://src/Main.tscn")
