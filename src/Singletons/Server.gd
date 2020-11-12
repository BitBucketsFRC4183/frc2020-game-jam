# all server specific functions go here
extends Node

# which players are ready
var players_ready = []

# The current day
var day := 0

# default to single_player
var single_player := true

# have we started the game already?
var started := false

onready var timer := $DaysTimer

func _ready():
	Signals.connect("player_ready_to_start", self, "player_ready_to_start")
	Signals.connect("post_start_game", self, "post_start_game")
	Signals.connect("player_joined", self, "_on_player_joined")

	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	timer.wait_time = Constants.seconds_per_day


# A new player has connected to the game
func _player_connected(id):
	if get_tree().is_network_server():
		# if we aren't the server, we don't
		# care about players connecting to us
		# we will wait for the player_updated call
		print("Server: Player connected: %d" % id)


# Callback from SceneTree.
func _player_disconnected(id):
	PlayersManager.remove_player(id)

func player_ready_to_start(id: int):	
	# A player is ready to start
	assert(get_tree().is_network_server())	

	if not id in players_ready:
		players_ready.append(id)

	if players_ready.size() == PlayersManager.players_by_network_id.size():
		print("Server: All players ready, sending post_start_game")
		RPC.send_post_start_game()

func begin_game(single_player := true):

	# The server/host is always player 1
	var player = PlayersManager.add_player(get_tree().get_network_unique_id())

	RPC.send_pre_start_game(PlayersManager.players)


func post_start_game():
	# the server needs to start the timer
	$DaysTimer.start()
	started = true


func _on_DaysTimer_timeout():
	day += 1
	# print_debug("Server: It\'s a new day! %d" % day)
	
	# send a message to clients
	RPC.send_server_day_updated(day)

func _on_player_joined(id: int, player_name: String) -> void:
	# TODO: Support player_name. For now it's randomly assigned
	var player = PlayersManager.add_player(id)
	print("Player %s joined, assumed player %s - %s" % [id, player.num, player.name])
	RPC.send_player_updated(player)

	# also send the player our host information
	RPC.send_player_updated(PlayersManager.whoami())

	RPC.send_pre_start_game([])
	RPC.send_post_start_game()
