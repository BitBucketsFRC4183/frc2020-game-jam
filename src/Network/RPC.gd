# The RPC Singleton is a place to hold all of our remote functions
# called by clients to send messages or servers to notify clients of messages
#
# This class contains two types of functions, send_* functions to make RPC calls to clients or the server
# and the actual remote methods that are executed by the clients or servers in response to the send_* method
extends Node

# a few notes on RPCs
# remotesync - means "execute on all clients including me". This is used for calls that execute on the server and client
# remote - means "execute on all clients except me". This is used for the server to broadcast to clients
# remote with rpc_id(1, ...) means execute only on the server. The server has an id of 1

###
### This is player management stuff
###
func send_server_day_updated(day):
	assert(get_tree().is_network_server())

	# Make an RPC to notify clients of a new day
	rpc("server_day_updated", day)

remotesync func server_day_updated(day):
	# The server calls this function and it executes on each clients
	# each client uses it to update it's current day
	# print_debug ("Client: a new day: %d" % day)

	Signals.emit_signal("day_passed", day)

func send_join_game(player_name: String) -> void:
	# tell the server we joined the game
	print("Sending player_joined call to server for %s" % get_tree().get_network_unique_id())
	rpc_id(1, "player_joined", player_name)

remotesync func player_joined(player_name: String) -> void:
	print("Received player_joined message for %s from %s" % [player_name, get_tree().get_rpc_sender_id()])
	Signals.emit_signal("player_joined", get_tree().get_rpc_sender_id(), player_name)

func send_pre_start_game(player_dicts: Array, id: int = 0):
	# notify clients we are all ready to start
	assert(get_tree().is_network_server())

	if id == 0:
		print("Server: Notifying all clients to prepare to start")

		# Call to pre-start game for everyone to get setup
		rpc("pre_start_game", player_dicts)
	else:
		print("Server: Notifying client %s to prepare to start" % id)

		# Call to pre-start game for everyone to get setup
		rpc_id(id, "pre_start_game", player_dicts)


remotesync func pre_start_game(players: Array):
	# Do any prep work to start the game, like create world, setup players, etc
	print("Client: Preparing to start game")
	Signals.emit_signal("pre_start_game", players)


func send_ready_to_start():
	print("Client: Sending ready_to_start to server")
	rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())


remotesync func ready_to_start(id):
	assert(get_tree().is_network_server())
	print("Server: Client %d is ready to start" % id)
	Signals.emit_signal("player_ready_to_start", id)

func send_post_start_game(id: int = 0):
	# sent by the server when all players are ready and we have begun
	if id == 0:
		rpc("post_start_game")
	else:
		rpc_id(id, "post_start_game")

remotesync func post_start_game():
	# this is called on both clients and servers after the game has started
	Signals.emit_signal("post_start_game")

func send_players_updated(player_dicts: Array):
	# sent our updated player info to all servers
	rpc("players_updated", player_dicts)

remote func players_updated(player_dicts: Array):
	Signals.emit_signal("players_updated", player_dicts);

###
### This is player actions
###

func send_game_building_placed(building_type_name: String, position: Vector2):
	# tell the other players about our placed building
	rpc("game_building_placed", building_type_name, position)

remote func game_building_placed(building_type_name: String, position: Vector2):
	# Message sent to us from another player about a building placement
	Signals.emit_signal("game_building_placed", PlayersManager.get_player_num(get_tree().get_rpc_sender_id()), building_type_name, position)

func send_asteroid(position: Vector2, asteroid_strength: int, attributes: Dictionary):
	rpc("asteroid_incoming", position, asteroid_strength, attributes)

remote func asteroid_incoming(position: Vector2, asteroid_strength:int, attributes: Dictionary):
	Signals.emit_signal("asteroid_incoming", position, asteroid_strength, attributes)

func send_asteroid_position_update(asteroid_id: int, position: Vector2):
	rpc_unreliable("asteroid_position_updated", asteroid_id, position)

remote func asteroid_position_updated(asteroid_id: int, position: Vector2):
	Signals.emit_signal("asteroid_position_updated", asteroid_id, position)

func send_asteroid_impact(asteroid_id: int, position: Vector2, explosion_radius: float):
	rpc("asteroid_impact", asteroid_id, position, explosion_radius)

remote func asteroid_impact(asteroid_id: int, position: Vector2, explosion_radius: float):
	Signals.emit_signal("asteroid_impact", asteroid_id, position, explosion_radius)


func send_player_give_resources(source_player_num: int, dest_player_num: int, resource_type: int, amount: int):
	rpc("player_give_resources", source_player_num, dest_player_num, resource_type, amount)

remote func player_give_resources(source_player_num: int, dest_player_num: int, resource_type: int, amount: int):
	Signals.emit_signal("player_give_resources", source_player_num, dest_player_num, resource_type, amount)
