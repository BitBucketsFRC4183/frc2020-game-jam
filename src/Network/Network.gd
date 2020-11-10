# The Network object is a singleton to manage network connections. If we host the game, it's a server. If we join, it's a client
extends Node

# Default game port. Can be any number between 1024 and 49151.
const DEFAULT_PORT = 3000

# Max number of players.
const MAX_PLAYERS = 5

var peer: NetworkedMultiplayerENet = null

onready var server: Server = $Server
onready var playersManager: PlayersManager = $PlayersManager

func _ready():
	# wire this up so know when our signat fails to connect
	get_tree().connect("server_disconnected", self, "_server_disconnected")

	# these might belong in a lobby UI
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")

	
	# pass along some shared data to our child nodes
	server.playersManager = playersManager
	

# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	# We just connected to a server
	Signals.emit_signal("connected_to_server")


# Callback from SceneTree, only for clients (not server).
func _server_disconnected():
	Signals.emit_signal("server_disconnected")


# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	Signals.emit_signal("connection_to_server_failed")


func host_game(player_name):
	# create a new server
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	var player = playersManager.add_player(get_tree().get_network_unique_id())
	RPC.send_player_updated(player)


func join_game(ip, player_name):
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	RPC.send_player_name(player_name)




