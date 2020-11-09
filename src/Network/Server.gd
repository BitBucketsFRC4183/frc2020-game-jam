# all server specific functions go here
extends Node
class_name Server

signal on_day_updated(day)

var players_ready = []

# The current day
var day = 0

# these values are set by the parent Network node
var players
var game_lifecycle_manager: GameLifecycleManager
onready var parent = get_parent()

remote func ready_to_start(id):
	assert(get_tree().is_network_server())

	if not id in players_ready:
		players_ready.append(id)

	if players_ready.size() == players.size():
		for p in players:
			rpc_id(p, "post_start_game")
		game_lifecycle_manager.post_start_game()

func begin_game():
	assert(get_tree().is_network_server())

	# Call to pre-start game for everyone to get setup
	for p in players:
		rpc_id(p, "game_lifecycle_manager.pre_start_game", players)

	game_lifecycle_manager.pre_start_game(players)
	
	# the server needs to start the timer
	$DaysTimer.start()


func _on_DaysTimer_timeout():
	day += 1
	print ("Server: It's a new day! %d" % day)
	
	# this signal will trigger an RPC call on the Network class, so each client
	# will update their day
	emit_signal("on_day_updated", day)
