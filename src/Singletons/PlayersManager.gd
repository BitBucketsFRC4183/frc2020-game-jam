# This node manages the players in the game
extends Node

var PlayerData = preload("res://src/GameObjects/PlayerData.gd")
var PlayerColors = preload("res://assets/PlayerColors.tres")

# a list of players, by player index
var players = []

# players by their network id
var players_by_network_id: Dictionary

func _init():

	# some random names
	var names = Constants.random_names
	names.shuffle()

	# add players to our list
	for i in range(0, Constants.num_players):
		players.append(PlayerData.new(i, names[i], PlayerColors.colors[i+1]))


func _ready():
	Signals.connect("players_updated", self, "update_players")


func add_player(id: int, player_dict: Dictionary = {}) -> PlayerData:
	if !player_dict.empty():
		# We are adding a player with a dictionary, so that means
		# we need to replace an existing player with a new network_id/num
		var player = PlayerData.new(0, "", Color.black)
		player.from_dict(player_dict)
		player.ai_controlled = false
		if id != 0:
			# only add this player to the network list if it's a network controlled player
			players_by_network_id[id] = player
		players[player.num] = player

		print_debug("Player %s (network_id: %s) added to registry as %s" % [player.num, player.network_id, player.name])
	else:
		# find the first available player
		for player in players:
			if player.ai_controlled:
				player.ai_controlled = false
				player.network_id = id
				if id != 0:
					# only add this player to the network list if it's a network controlled player
					players_by_network_id[id] = player
				print_debug("Player %s (network_id: %s) added to registry as %s" % [player.num, player.network_id, player.name])
				break

	var added_player = players_by_network_id[id]
	Signals.emit_signal("player_owner_changed", added_player)
	return added_player


func remove_player(id: int):
	# reset this player to ai controlled
	players_by_network_id[id].ai_controlled = true
	players_by_network_id[id].network_id = 0
	players_by_network_id.erase(id)

	
func update_player(player_dict: Dictionary):
	var id: int = player_dict.get("network_id", -1)
	if (id == -1):
		printerr("We received an update for a player without a player network_id!")
		return
	
	var player: PlayerData
	if players_by_network_id.has(id):
		player = players_by_network_id[id]
		players_by_network_id[id].from_dict(player_dict)
		print_debug("Player %s - %s (network_id: %s) updated in PlayersManager" % [player.num, player.name, player.network_id])
	else:
		player = add_player(id, player_dict)
		print_debug("Player %s - %s (network_id: %s) added to PlayersManager" % [player.num, player.name, player.network_id])

func whoami() -> PlayerData:
	# return my player. Default to player 0 if none is defined
	var me = players_by_network_id.get(get_tree().get_network_unique_id(), null)
	if me == null:
		if not Server.single_player:
			print_debug("I don't exist in the player registry!")
		return players[0]
	else:
		return me

func get_player_num(network_id: int) -> int:
	if players_by_network_id.has(network_id):
		return players_by_network_id[network_id].num
	printerr("could not find player_num for network_id: %s" % network_id)
	return 0

func get_all_player_dicts() -> Array:
	# get all the PlayerDatas as dicts to send over the wire
	var player_dicts = []
	for player in players:
		player_dicts.append(player.to_dict())
	return player_dicts

func update_players(player_dicts: Array):
	# update all players in our dictionary
	for player_dict in player_dicts:
		update_player(player_dict)
