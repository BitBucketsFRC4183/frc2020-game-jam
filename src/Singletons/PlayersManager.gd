# This node manages the players in the game
extends Node

var PlayerData = preload("res://src/GameObjects/PlayerData.gd")

# a list of players, by player index
var players = []

# players by their network id
var players_by_network_id: Dictionary

func _init():

	# some random names
	var names = Constants.random_names
	names.shuffle()

	# add players to our list
	for i in range(5):
		players.append(PlayerData.new(i, names[i], Constants.player_colors[i]))

func _ready():
	Signals.connect("player_updated", self, "_on_player_updated")


func add_player(id: int):
	# find the first available player
	for player in players:
		if player.ai_controlled:
			player.ai_controlled = false
			player.network_id = id
			players_by_network_id[id] = player
			break
	return players_by_network_id[id]

func remove_player(id: int):
	# reset this player to ai controlled
	players_by_network_id[id].ai_controlled = true
	players_by_network_id[id].network_id = 0
	players_by_network_id.erase(id)

	
func _on_player_updated(id: int, player):
	players_by_network_id[id] = player
	print("Player %s (network_id: %s) - %s - has updated data" % [player.num, id, player.name])

func whoami() -> PlayerData:
	# return my player. Default to player 0 if none is defined
	var me = players_by_network_id.get(get_tree().get_network_unique_id(), null)
	if me == null:
		print_debug("I don't exist in the player registry!")
		return players[0]
	else:
		return me
