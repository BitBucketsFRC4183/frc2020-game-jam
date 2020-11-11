# all server specific functions go here
extends Node
class_name Server

# which players are ready
var players_ready = []

# The current day
var day = 0


func _ready():
	Signals.connect("player_ready_to_start", self, "player_ready_to_start")
	Signals.connect("post_start_game", self, "post_start_game")

	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")


# A new player has connected to the game
func _player_connected(id):
	print("Server: Player connected: %d" % id)
	PlayersManager.add_player(id)


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

func begin_game():
	RPC.send_pre_start_game(PlayersManager.players)
	
func post_start_game():
	# the server needs to start the timer
	$DaysTimer.start()


func _on_DaysTimer_timeout():
	day += 1
	print_debug("Server: It\'s a new day! %d" % day)
	
	# send a message to clients
	RPC.send_server_day_updated(day)
