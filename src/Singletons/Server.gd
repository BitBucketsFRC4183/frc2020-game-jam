# all server specific functions go here
extends Node

# which players are ready
var players_ready = []

# The current day
var day := 0
var asteroid_timer: Timer

# default to single_player
var single_player := false

# have we started the game already?
var started := false

# are we on easy mode?
var easy := false

onready var timer := $DaysTimer

func _ready():
	Signals.connect("player_ready_to_start", self, "player_ready_to_start")
	Signals.connect("post_start_game", self, "post_start_game")
	Signals.connect("player_joined", self, "_on_player_joined")

	Signals.connect("asteroid_wave_started", self, "_on_asteroid_wave_started")
	Signals.connect("grand_winner", self, "reset_values")
	Signals.connect("winner", self, "reset_values")
	Signals.connect("loser", self, "_on_loser")
	Signals.connect("final_wave_complete", self, "_on_final_wave_complete")

	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")

	reset_values()

func reset_values():
	players_ready = []
	day = 0
	single_player = false
	started = false
	timer.stop()
	timer.wait_time = Constants.seconds_per_day


# A new player has connected to the game
func _player_connected(id):
	if get_tree().is_network_server():
		# if we aren't the server, we don't
		# care about players connecting to us
		# we will wait for the players_updated call
		print("Server: Player connected: %d" % id)


# A player disconnected from the server, remove them
func _player_disconnected(id):
	var player = PlayersManager.get_network_player(id)
	PlayersManager.remove_player(id)
	RPC.send_players_updated(PlayersManager.get_all_player_arrays())
	if player:
		RPC.send_message("Player %s has left the game." % player.num)


func is_ready_to_start() -> bool:
	return players_ready.size() == PlayersManager.players_by_network_id.size()

func player_ready_to_start(id: int, ready: bool):
	# A player is ready to start
	assert(get_tree().is_network_server())

	var player = PlayersManager.get_network_player(id)
	player.ready = ready

	if ready:
		players_ready.append(id)
	else:
		players_ready.erase(id)

	# notify everyone a player's readiness changed
	RPC.send_players_updated(PlayersManager.get_all_player_arrays())
	Signals.emit_signal("player_data_updated", player)

	if started:
		print("Server: New player ready, sending post_start_game")
		RPC.send_post_start_game(id)

func begin_game(single_player := true):

	if easy:
		PlayersManager.double_resources()
	# The server/host is always player 1
	var player = PlayersManager.add_player(get_tree().get_network_unique_id())
	RPC.send_message("%s(%s) has joined the game." % [player.name, player.num])

	RPC.send_pre_start_game(PlayersManager.get_all_player_arrays())


func post_start_game():
	print("post_start_game: is_network_server: %s" % get_tree().is_network_server())
	if get_tree().is_network_server():
		# the server needs to start the timer
		$DaysTimer.start()
		started = true
		Signals.emit_signal("server_started")


func _on_DaysTimer_timeout():
	day += 1
	# print_debug("Server: It\'s a new day! %d" % day)

	# send a message to clients
	RPC.send_server_day_updated(day, asteroid_timer.time_left if asteroid_timer else 0.0)


func _on_asteroid_wave_started(wave: int, waves: int):
	RPC.send_asteroid_wave_started(wave, waves)


func _on_final_wave_complete():
	reset_values()
	RPC.send_players_updated(PlayersManager.get_all_player_arrays())
	RPC.send_final_wave_complete()


func _on_loser():
	reset_values()
	RPC.send_players_updated(PlayersManager.get_all_player_arrays())
	RPC.send_loser()


func _on_player_joined(id: int) -> void:
	# add this new player to the server's PlayersManager
	var player = PlayersManager.add_player(id)

	RPC.send_message("%s(%s) has joined the game." % [player.name, player.num])

	# send our player data to all clients, so everyone knows about the new player
	RPC.send_players_updated(PlayersManager.get_all_player_arrays())
	RPC.send_all_messages(PlayersManager.player_messages, id)

	if started:
		# if we already started the game, tell this new player to join us
		RPC.send_pre_start_game(PlayersManager.get_all_player_arrays(), id)
		RPC.send_post_start_game(id)
