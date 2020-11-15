extends Node2D

var Player = preload("res://src/GameObjects/Player.tscn")

var isTechTreeOpen
var isLeaderboardOpen
var num_asteroids_hit := 0

# use these to ignore events
var game_over := false

var num_of_territories = [
	0,
	0,
	0,
	0,
	0
]


var num_of_destroyed = [
	0,
	0,
	0,
	0,
	0
]

func _ready():
	if not get_tree().has_network_peer() and not Server.started:
		# this is only for launching the World scene directly when developing
		Network.host_game(true)
		Server.begin_game(true)
		RPC.send_ready_to_start(true)
		RPC.send_post_start_game()

	isTechTreeOpen = false
	$AsteroidManager.territories = $Map.get_territories()

	_add_players_to_world()

	Signals.connect("final_wave_complete", self, "win_game")
	Signals.connect("territory_destroyed", self, "_on_territory_destroyed")

	make_territories_list()

	if get_tree().is_network_server():
		# hack, but we need to tell our server about the asteroid timer
		Server.asteroid_timer = $AsteroidManager/Timer


func win_game():
	if game_over:
		# only do this once
		return
	game_over = true
	# let our people revel in success
	$EndGameDelayTimer.connect("timeout", self, "_on_end_game_win")
	$EndGameDelayTimer.start()


func _on_end_game_win():
	var player_with_highest_score = PlayersManager.whoami().num
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
	if game_over:
		# only do this once
		return
	game_over = true
	# let our stuff get all messed up and damaged before
	# we transition
	$EndGameDelayTimer.connect("timeout", self, "_on_end_game_lose")
	$EndGameDelayTimer.start()

func _on_end_game_lose():
	Signals.emit_signal("loser")
	get_tree().change_scene("res://src/GUI/LoseScreen.tscn")


func make_territories_list():
	var territories = $Map.get_territories()
	for t in territories:
		if t.territory_owner > 0 && t.territory_owner <= num_of_territories.size():
			num_of_territories[t.territory_owner-1] += 1

func _on_territory_destroyed(t: Territory):
	if t.territory_owner > 0 and t.territory_owner <= num_of_territories.size() and t.territory_owner <= num_of_destroyed.size():
		num_of_destroyed[t.territory_owner - 1] += 1

		if num_of_destroyed[t.territory_owner - 1] == num_of_territories[t.territory_owner - 1]:
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
