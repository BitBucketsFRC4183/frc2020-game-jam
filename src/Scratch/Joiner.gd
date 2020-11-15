# this is a test node for automatically joining a game
# call this from the command line with
# godot src/Scratch/Joiner.tscn
extends MarginContainer

func _ready():
	Network.join_game("127.0.0.1", Settings.server_port)

	# TODO: don't change scenes until we get the final ready from the server
	Signals.connect("pre_start_game", self, "_on_pre_start_game")
	Signals.connect("post_start_game", self, "_on_post_start_game")

func _on_pre_start_game(players: Array):
	# tell the server we are ready
	PlayersManager.update_players(players)
	RPC.send_ready_to_start()
	
func _on_post_start_game():
	get_tree().change_scene("res://src/World.tscn")
