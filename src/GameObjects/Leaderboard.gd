extends Control

var players = ["Player 1", "Player 2", "Player 3", "Player 4", "Player 5"]

func _ready():
	
	var font = DynamicFont.new()
	font.set_font_data(load("res://assets/TechTreeFont.ttf"))
	font.set_size(36)
	
	for i in range (1, 6):
		get_node("Leaderboard/Player" + str(i) + "/Stats").add_font_override("font", font)
	
	pass

func on_show():
	for i in range (1, 6):
		update_player_data(i)
	set_leaderboard_rows()
	pass
	
func update_player_data(num: int):
	var p = PlayersManager.get_player(num)
	
	var stat = "%s :   Score = %s   Raw = %s   Power = %s   Science = %s" % [p.name, p.score, p.resources[Enums.resource_types.raw], p.resources[Enums.resource_types.power], p.resources[Enums.resource_types.science]]
	players[num - 1] = stat
	pass

func set_leaderboard_rows():
	var node = ""
	for i in range (1, 6):
		node = "Leaderboard/Player" + str(i) + "/Stats"
		get_node(node).set_text(players[i - 1])
	pass
