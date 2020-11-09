# The Network object is a singleton to manage network connections. If we host the game, it's a server. If we join, it's a client
extends Node

# Default game port. Can be any number between 1024 and 49151.
const DEFAULT_PORT = 3000

# Max number of players.
const MAX_PLAYERS = 5

var peer: NetworkedMultiplayerENet = null

# Name for the current player
var player_name = "no_name_yet"

# Names for remote players in id:name format.
var players = {}


# Signals to let lobby GUI know what's going on.
signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

onready var game_lifecycle_manager: GameLifecycleManager = $GameLifecycleManager
onready var lobby_manager: LobbyManager = $LobbyManager
onready var client: Client = $Client
onready var server: Server = $Server

func _ready():
	# when the Server node is created, hook up the network events
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	# pass along some shared data to our child nodes
	lobby_manager.players = players
	server.players = players
	server.game_lifecycle_manager = game_lifecycle_manager
	
	server.connect("on_day_updated", self, "_on_day_updated")
	

# A new player has connected to the game
func _player_connected(id):
	# Registration of a client beings here, tell the connected player that we are here.
	rpc_id(id, "lobby_manager.register_player", player_name)


# Callback from SceneTree.
func _player_disconnected(id):
	if has_node("/root/World"): # Game is in progress.
		if get_tree().is_network_server():
			emit_signal("game_error", "Player " + players[id] + " disconnected")
			end_game()
	else: # Game is not in progress.
		# Unregister this player.
		lobby_manager.unregister_player(id)


# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	# We just connected to a server
	emit_signal("connection_succeeded")


# Callback from SceneTree, only for clients (not server).
func _server_disconnected():
	emit_signal("game_error", "Server disconnected")
	end_game()

# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")


func host_game(new_player_name):
	player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)


func join_game(ip, new_player_name):
	player_name = new_player_name
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)


func end_game():
	if has_node("/root/World"): # Game is in progress.
		# End it
		get_node("/root/World").queue_free()

	emit_signal("game_ended")
	players.clear()


remotesync func server_day_updated(day):
	# This is a remotesync function, so it executes over the network and locally
	print ("Client: a new day: %d" % day)

	Signals.emit_signal("day_passed", day)

func _on_Server_day_updated(day):
	# This is connected up to the Server's "day_updated" signal
	rpc("server_day_updated", day)

