extends Node2D

var isTechTreeOpen

func _ready():
	isTechTreeOpen = false
	$AsteroidManager.territories = $Map.get_territories()

	if not Network.server.started:
		Network.host_game("Single Player", true)
		Network.server.begin_game(true)
		RPC.send_ready_to_start()

func _input(event):
	if(event.is_action_pressed("ui_tech_tree")):
		if(!isTechTreeOpen):
			$CanvasLayer/TechTree.show()
			$Map.hide()
			$AsteroidManager.hide()
			$CanvasLayer/GUI.hide()
		else:
			$CanvasLayer/TechTree.hide()
			$Map.show()
			$AsteroidManager.show()
			$CanvasLayer/GUI.show()	
		isTechTreeOpen = !isTechTreeOpen
