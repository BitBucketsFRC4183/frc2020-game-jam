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
### the server day message is kind of a "sync up with the server" message
###
func send_server_day_updated(day: int, asteroid_time_left: float):
	assert(get_tree().is_network_server())

	# Make an RPC to notify clients of a new day
	rpc_unreliable("server_day_updated", day, asteroid_time_left, PlayersManager.get_all_player_arrays())


remotesync func server_day_updated(day: int, asteroid_time_left: float, player_arrays: Array):
	# The server calls this function and it executes on each clients
	# each client uses it to update it's current day
	# print_debug ("Client: a new day: %d" % day)

	# update all the player dicts from the server
	if not get_tree().is_network_server():
		Signals.emit_signal("players_updated", player_arrays)
	Signals.emit_signal("asteroid_wave_timer_updated", asteroid_time_left)
	Signals.emit_signal("day_passed", day)

###
### This is player management stuff
###
func send_join_game() -> void:
	# tell the server we joined the game
	print("Sending player_joined call to server for %s" % get_tree().get_network_unique_id())
	rpc_id(1, "player_joined")

remotesync func player_joined() -> void:
	print("Received player_joined message for network id %s" % [get_tree().get_rpc_sender_id()])
	Signals.emit_signal("player_joined", get_tree().get_rpc_sender_id())

func send_pre_start_game(player_arrays: Array, id: int = 0):
	# notify clients we are all ready to start
	assert(get_tree().is_network_server())

	if id == 0:
		print("Server: Notifying all clients to prepare to start")

		# Call to pre-start game for everyone to get setup
		rpc("pre_start_game", player_arrays)
	else:
		print("Server: Notifying client %s to prepare to start" % id)

		# Call to pre-start game for everyone to get setup
		rpc_id(id, "pre_start_game", player_arrays)


remotesync func pre_start_game(players: Array):
	# Do any prep work to start the game, like create world, setup players, etc
	print("Client: Preparing to start game")
	Signals.emit_signal("pre_start_game", players)

func send_message(message: String):
	var player = PlayersManager.whoami()
	rpc_unreliable("message", PlayerMessage.new(player.num, message).to_dict())

remotesync func message(message_dict: Dictionary):
	var message = Utils.player_message_from_dict(message_dict)
	var player = PlayersManager.get_player(message.num)
	print("%s%s: %s" % ["Host - " if player.num == 1 else "", player.name, message.message])
	Signals.emit_signal("player_message", message)

func send_all_messages(messages: Array, id: int = -1):
	# server sends all messages on startup
	assert(get_tree().is_network_server())
	var message_dicts = []
	for message in messages:
		message_dicts.append(message.to_dict())
	if id != -1:
		rpc("all_messages", message_dicts)
	else:
		rpc_id(id, "all_messages", message_dicts)

remote func all_messages(messages: Array):
	PlayersManager.player_messages.clear()
	for message_dict in messages:
		Signals.emit_signal("player_message", Utils.player_message_from_dict(message_dict))


func send_ready_to_start(ready: bool):
	# tell the server we are ready or not
	print("Client: Sending ready_to_start to server")
	rpc_id(1, "ready_to_start", ready)


remotesync func ready_to_start(ready: bool):
	assert(get_tree().is_network_server())
	var id = get_tree().get_rpc_sender_id()
	print("Server: Client %d is ready to start" % id)
	Signals.emit_signal("player_ready_to_start", id, ready)

func send_post_start_game(id: int = 0):
	# sent by the server when all players are ready and we have begun
	if id == 0:
		rpc("post_start_game")
	else:
		rpc_id(id, "post_start_game")

remotesync func post_start_game():
	# this is called on both clients and servers after the game has started
	Signals.emit_signal("post_start_game")

func send_players_updated(player_arrays: Array):
	# sent our updated player info to all servers
	rpc_unreliable("players_updated", player_arrays)


remote func players_updated(player_arrays: Array):
	Signals.emit_signal("players_updated", player_arrays);

###
### This is player actions
###

func send_game_building_placed(building_id: String, building_type_name: String, position: Vector2):
	# tell the other players about our placed building
	rpc_unreliable("game_building_placed", building_id, building_type_name, position)

remote func game_building_placed(building_id: String, building_type_name: String, position: Vector2):
	# Message sent to us from another player about a building placement
	Signals.emit_signal("game_building_placed", building_id, PlayersManager.get_player_num(get_tree().get_rpc_sender_id()), building_type_name, position)

###
### Asteroid stuff
###

func send_asteroid_wave_started(wave: int, waves: int):
	rpc("asteroid_wave_started", wave, waves)


remote func asteroid_wave_started(wave: int, waves: int):
	Signals.emit_signal("asteroid_wave_started", wave, waves)


func send_asteroid(position: Vector2, asteroid_strength: int, attributes: Array):
	rpc_unreliable("asteroid_incoming", position, asteroid_strength, attributes)

remote func asteroid_incoming(position: Vector2, asteroid_strength:int, attributes: Array):
	Signals.emit_signal("asteroid_incoming", position, asteroid_strength, attributes)

func send_asteroid_position_update(asteroid_id: int, position: Vector2):
	rpc_unreliable("asteroid_position_updated", asteroid_id, position)

remote func asteroid_position_updated(asteroid_id: int, position: Vector2):
	Signals.emit_signal("asteroid_position_updated", asteroid_id, position)

func send_asteroid_impact(asteroid_id: int, position: Vector2, explosion_radius: float):
	rpc_unreliable("asteroid_impact", asteroid_id, position, explosion_radius)

remote func asteroid_impact(asteroid_id: int, position: Vector2, explosion_radius: float):
	Signals.emit_signal("asteroid_impact", asteroid_id, position, explosion_radius)


func send_asteroid_destroyed(asteroid_id: int, position: Vector2, size):
	rpc_unreliable("asteroid_destroyed", asteroid_id, position, size)

remote func asteroid_destroyed(asteroid_id: int, position: Vector2, size):
	Signals.emit_signal("asteroid_destroyed", asteroid_id, position, size)

#
# Shields
#
func send_shield_update(building_id: String, active: bool):
	# the server will notify clients when shields go down
	rpc_unreliable("shield_update", building_id, active)

remote func sheild_update(building_id: String, active: bool):
	Signals.emit_signal("shield_update", building_id, active)

func send_shield_damaged(building_id: String, damage):
	# the server will notify clients when shields take damage, but it could happen a bunch
	# at once, so make it UDP. This is just for effects
	rpc_unreliable("shield_damaged", building_id, damage)

remote func shield_damaged(building_id: String, damage):
	Signals.emit_signal("shield_damaged", building_id, damage)

func send_player_give_resources(source_player_num: int, dest_player_num: int, resource_type: int, amount: int):
	rpc_unreliable("player_give_resources", source_player_num, dest_player_num, resource_type, amount)

remote func player_give_resources(source_player_num: int, dest_player_num: int, resource_type: int, amount: int):
	Signals.emit_signal("player_give_resources", source_player_num, dest_player_num, resource_type, amount)

#
# End Game
#
func send_final_wave_complete():
	rpc("final_wave_complete")


remote func final_wave_complete():
	# tell clients we survivied the final wave!
	Signals.emit_signal("final_wave_complete")


func send_loser():
	rpc("loser")


remote func loser():
	# tell clients we survivied the final wave!
	Signals.emit_signal("loser")
