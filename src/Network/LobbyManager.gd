# Lobby management functions.
extends Node
class_name LobbyManager

var players

remote func register_player(new_player_name):
	var id = get_tree().get_rpc_sender_id()
	print("Registering new player %s" % id)
	players[id] = new_player_name
	emit_signal("player_list_changed")


func unregister_player(id):
	print("Unregistering new player %s" % id)
	players.erase(id)
	emit_signal("player_list_changed")

