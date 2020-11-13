extends Node2D

var Player = preload("res://src/GameObjects/Player.tscn")

var isTechTreeOpen

func _ready():
	if not get_tree().has_network_peer() and not Server.started:
		Network.host_game("Single Player", true)
		Server.begin_game(true)
		RPC.send_ready_to_start()

	isTechTreeOpen = false
	$AsteroidManager.territories = $Map.get_territories()
	
	_add_players_to_world()

func _add_players_to_world():
	for player_data in PlayersManager.players:
		var player_node = Player.instance()
		player_node.data = player_data
		add_child(player_node)


func _input(event):
	if(event.is_action_pressed("ui_tech_tree")):
		if(!isTechTreeOpen):
			show_tech_tree()
		else:
			close_tech_tree()
		isTechTreeOpen = !isTechTreeOpen
	elif(event.is_action_pressed("escape") && isTechTreeOpen):
		close_tech_tree()

func close_tech_tree():
	$CanvasLayer/TechTree.hide()
	$Map.show()
	$AsteroidManager.show()
	$CanvasLayer/GUI.show()
	
func show_tech_tree():
	$CanvasLayer/TechTree.show()
	$Map.hide()
	$AsteroidManager.hide()
	$CanvasLayer/GUI.hide()
