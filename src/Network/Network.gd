# The Network object is a singleton to manage network connections. If we host the game, it's a server. If we join, it's a client
extends Node

var peer: NetworkedMultiplayerENet = null


func _ready():
	# wire this up so know when our signat fails to connect
	get_tree().connect("server_disconnected", self, "_server_disconnected")

	# these might belong in a lobby UI
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_connected_fail")


func _on_connected_to_server():
	# We just connected to a server
	Signals.emit_signal("connected_to_server")

	# tell the server we are joining and give them our name
	RPC.send_join_game()


# Callback from SceneTree, only for clients (not server).
func _server_disconnected():
	Signals.emit_signal("server_disconnected")


# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	Signals.emit_signal("connection_to_server_failed")


func host_game(single_player := true):
	# create a new server
	# for single player games, we have 0 users

	peer = NetworkedMultiplayerENet.new()
	peer.create_server(Settings.server_port, 1 if single_player else Constants.num_players)
	get_tree().set_network_peer(peer)

	if single_player:
		get_tree().refuse_new_network_connections = true


func join_game(ip, port):
	# connect to a server. When this is successful, we'll
	# get a connected_to_server event
	# when that comes in, we'll send a join request
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, port)
	get_tree().set_network_peer(peer)

func close_connection():
	if peer:
		peer.close_connection()
		get_tree().set_network_peer(null) # Remove peer
		peer = null
