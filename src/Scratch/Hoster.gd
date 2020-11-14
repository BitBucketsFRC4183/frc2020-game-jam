# This is test node for launching a network host
extends Node2D

func _ready():
	Signals.connect("pre_start_game", self, "_on_pre_start_game")

	Network.host_game("Host", false)
	Server.begin_game(false)

func _on_pre_start_game(players: Array):
	# tell the server we are ready
	RPC.send_ready_to_start()
	get_tree().change_scene("res://src/World.tscn")

