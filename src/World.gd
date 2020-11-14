extends Node2D

var Player = preload("res://src/GameObjects/Player.tscn")

var isTechTreeOpen
var isLeaderboardOpen
var num_asteroids_hit := 0

var num_of_territories = {
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0
}

func _ready():
	if not get_tree().has_network_peer() and not Server.started:
		Network.host_game("Single Player", true)
		Server.begin_game(true)
		RPC.send_ready_to_start()

	isTechTreeOpen = false
	$AsteroidManager.territories = $Map.get_territories()

	_add_players_to_world()

	if Constants.play_music:
		$Music.play()

	Signals.connect("final_wave_complete", self, "win_game")
	Signals.connect("asteroid_impact", self, "_on_asteroid_impact")


	make_territories_list()


func win_game():
	var player_with_highest_score = 1
	var highest_score = PlayersManager.whoami().score

	for p in PlayersManager.players:
		if p.score > highest_score:
			player_with_highest_score = p.num
			highest_score = p.score

	if player_with_highest_score == PlayersManager.whoami().num:
		Signals.emit_signal("grand_winner")
		get_tree().change_scene("res://src/GUI/GrandWinScreen.tscn")
	else:
		Signals.emit_signal("winner")
		get_tree().change_scene("res://src/GUI/WinScreen.tscn")


func lose_game():
	Signals.emit_signal("loser")
	get_tree().change_scene("res://src/GUI/LoseScreen.tscn")


func make_territories_list():
	var territories = $Map.get_territories()
	for t in territories:
		num_of_territories[t.territory_owner] += 1

func _on_asteroid_impact(asteroid_id, impact_point, explosion_radius):
	var territories = $Map.get_territories()

	# for each player id
	for player in PlayersManager.players:
		var id = player.num
		var tiles_destroyed = 0
		# we go through every territory in the map
		for t in territories:
			# only check territory for curernt player
			if t.territory_owner == id:
				# if there is a non-destroyed tile, set flag to true
				# re-start loop which will hit the if statement below
				if t.type == Enums.territory_types.destroyed:
					tiles_destroyed += 1
					if tiles_destroyed == num_of_territories[id]:
						lose_game()


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
		if(isLeaderboardOpen):
				$CanvasLayer/Leaderboard.hide()
		isTechTreeOpen = !isTechTreeOpen		
	elif(event.is_action_pressed("ui_leaderboard")):
		if(!isLeaderboardOpen):
			show_leaderboard()
		else:
			close_leaderboard()
		if(isTechTreeOpen):
				$CanvasLayer/TechTree.hide()
		isLeaderboardOpen = !isLeaderboardOpen
	elif(event.is_action_pressed("escape")):
		if isTechTreeOpen:
			close_tech_tree()
		if isLeaderboardOpen:
			close_leaderboard()

func show_leaderboard():
	$CanvasLayer/Leaderboard.show()
	close_map()
	
func close_leaderboard():
	$CanvasLayer/Leaderboard.hide()
	show_map()

func close_tech_tree():
	$CanvasLayer/TechTree.hide()
	show_map()

func show_tech_tree():
	$CanvasLayer/TechTree.show()
	close_map()

func show_map():
	$Map.show()
	$AsteroidManager.show()
	$CanvasLayer/GUI.show()

func close_map():
	$Map.hide()
	$AsteroidManager.hide()
	$CanvasLayer/GUI.hide()
