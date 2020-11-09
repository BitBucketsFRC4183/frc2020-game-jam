extends Node
class_name GameLifecycleManager

remote func pre_start_game(players):
	pass
	# Change scene.
	# var world = load("res://src/GameObjects/World.tscn").instance()
	# get_tree().get_root().add_child(world)

	# get_tree().get_root().get_node("Lobby").hide()

#	var player_scene = load("res://player.tscn")
#
#
#	# Set up score.
#	# world.get_node("Score").add_player(get_tree().get_network_unique_id(), player_name)
#	for player in players:
#		world.get_node("Players").add_child(player)
#
#	if not get_tree().is_network_server():
#		# Tell server we are ready to start.
#		rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())
#	elif players.size() == 0:
#		post_start_game()


remote func post_start_game():
	get_tree().set_pause(false) # Unpause and unleash the game!


