# this is a test node for automatically joining a game
# call this from the command line with
# godot src/Scratch/Joiner.tscn
extends Node2D

func _ready():
	Network.join_game("127.0.0.1", "Joiner")

	# TODO: don't change scenes until we get the final ready from the server
	Signals.connect("post_start_game", self, "_on_post_start_game")

func _on_post_start_game():
	get_tree().change_scene("res://src/World.tscn")
