extends Node2D

func _ready():
	$AsteroidManager.territories = $Map.get_territories()

	if not Network.server.started:
		Network.host_game("Single Player", true)
		Network.server.begin_game(true)
		RPC.send_ready_to_start()
	
