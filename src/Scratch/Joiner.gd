# this is a test node for automatically joining a game
# call this from the command line with
# godot src/Scratch/Joiner.tscn
extends Node2D

func _ready():
	Network.join_game("127.0.0.1", "Joiner")
	get_tree().change_scene("res://src/World.tscn")
