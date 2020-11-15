# This node manages the players in the game
extends Node

var PlayerData = preload("res://src/GameObjects/PlayerData.gd")
var PlayerColors = preload("res://assets/PlayerColors.tres")

# a list of players, by player index
var players = []
var player_messages = []

# players by their network id
var players_by_network_id: Dictionary

func _ready():
	Signals.connect("players_updated", self, "update_players")
	Signals.connect("player_message", self, "_on_player_message")

	#Signals.connect("grand_winner", self, "reset_values")
	#Signals.connect("winner", self, "reset_values")
	#Signals.connect("loser", self, "reset_values")
	reset_values()

func reset_values():
	players = []
	player_messages = []
	players_by_network_id = {}
	set_names()

func _on_player_message(message: PlayerMessage):
	player_messages.append(message)


func double_resources(add_science=true):
	# quick and dirty easy mode, double resources
	for p in players:
		for r in p.resources.keys():
			p.resources[r] = p.resources[r] * 2
		if add_science:
			p.resources[Enums.resource_types.science] = p.resources[Enums.resource_types.raw]
	

func set_names():
	# some random names
	var names = Constants.random_names
	names.shuffle()

	# add players to our list
	# start from 1 since territories go from 1
	for i in range(1, Constants.num_players+1):
		players.append(PlayerData.new(i, names[i - 1], PlayerColors.colors[i]))

func add_player(id: int, player_dict: Dictionary = {}) -> PlayerData:
	var player: PlayerData

	if !player_dict.empty():
		# We are adding a player with a dictionary, so that means
		# we need to replace an existing player with a new network_id/num
		player = PlayerData.new(1, "", Color.black)

		player.from_dict(player_dict)
		if id != 0:
			# only add this player to the network list if it's a network controlled player
			players_by_network_id[id] = player
		players[player.num - 1] = player

		# print_debug("Player %s (network_id: %s) added to registry as %s" % [player.num, player.network_id, player.name])
	else:
		# find the first available player
		for existing_player in players:
			if existing_player.ai_controlled:
				existing_player.ai_controlled = false
				existing_player.ready = false
				existing_player.network_id = id
				if id != 0:
					# only add this player to the network list if it's a network controlled player
					players_by_network_id[id] = existing_player
				player = existing_player
				# print_debug("Player %s (network_id: %s) added to registry as %s" % [player.num, player.network_id, player.name])
				break

	Signals.emit_signal("player_data_updated", player)
	return player


func remove_player(id: int) -> PlayerData:
	# reset this player to ai controlled
	if players_by_network_id.has(id):
		var player = players_by_network_id[id]
		players_by_network_id[id].ai_controlled = true
		players_by_network_id[id].ready = true
		players_by_network_id[id].network_id = 0
		players_by_network_id.erase(id)
		Signals.emit_signal("player_data_updated", player)
		return player
	return null



func update_player(player_dict: Dictionary):
	var id: int = player_dict.get("network_id", -1)
	if (id == -1):
		printerr("We received an update for a player without a player network_id!")
		return

	var player: PlayerData
	if players_by_network_id.has(id):
		player = players_by_network_id[id]
		players_by_network_id[id].from_dict(player_dict)
		Signals.emit_signal("player_data_updated", player)
		# print_debug("Player %s - %s (network_id: %s) updated in PlayersManager" % [player.num, player.name, player.network_id])
	else:
		player = add_player(id, player_dict)
		# print_debug("Player %s - %s (network_id: %s) added to PlayersManager" % [player.num, player.name, player.network_id])

func whoami() -> PlayerData:
	# return my player. Default to player 0 if none is defined
	var me = players_by_network_id.get(get_tree().get_network_unique_id(), null)
	if me == null:
		if not Server.single_player:
			if not Engine.editor_hint:
				print_debug("I don't exist in the player registry!")
		return players[0]
	else:
		return me


func get_player(player_num: int) -> PlayerData:
	# get the player based on their number
	if player_num > 0 && player_num <= players.size():
		return players[player_num - 1]
	printerr("Tried to get a player with player_num %s" % player_num)
	if Engine.editor_hint or players.size() == 0:
		# return an empty player for the editor
		return PlayerData.new(player_num, Constants.random_names[player_num], PlayerColors.colors[player_num])
	return players[0]

func get_network_player(network_id: int) -> PlayerData:
	if players_by_network_id.has(network_id):
		return players_by_network_id[network_id]
	else:
		printerr("could not find player_num for network_id: %s" % network_id)
		return null


func get_player_num(network_id: int) -> int:
	var player = get_network_player(network_id)
	if player:
		return player.num
	else:
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
