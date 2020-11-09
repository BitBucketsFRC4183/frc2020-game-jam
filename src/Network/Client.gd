# Clients use this class to send requests to the server
extends Node
class_name Client

func send_ready_to_start():
	# send a ready to start message to the server
	if not get_tree().is_network_server():
		# Tell server we are ready to start.
		rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())
