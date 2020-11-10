# This node manages the players in the game
extends Node
class_name PlayersManager

var players: Dictionary

func _ready():
	Signals.connect("player_updated", self, "_on_player_updated")
	Signals.connect("player_name_updated", self, "_on_player_name_updated")


func add_player(id: int):
	players[id] = PlayerData.new()
	return players[id]

func remove_player(id: int):
	# remove this player from the dictionary
	players.erase(id)

func _on_player_name_updated(id: int, name: String):
	players[id].name = name
	RPC.send_player_updated(players[id])
	
func _on_player_updated(id: int, player):
	players[id] = player
	print_debug("Player %s has updated data" % id)
