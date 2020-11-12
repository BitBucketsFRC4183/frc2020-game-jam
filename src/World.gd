extends Node2D

func _ready():
	$AsteroidManager.territories = $Map.get_territories()

	if not Server.started:
		Network.host_game("Single Player", true)
		Server.begin_game(true)
		RPC.send_ready_to_start()

