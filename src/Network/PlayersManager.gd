# This node manages the players in the game
extends Node
class_name PlayersManager

var players: Dictionary

func _ready():
	Signals.connect("player_name_updated", self, "_on_player_name_updated")


func add_player(id: int):
	players[id] = {}

func remove_player(id: int):
	# remove this player from the dictionary
	players.erase(id)

func _on_player_name_updated(id: int, name: String):
	players[id]["name"] = name

