extends Button

var isLeaderboardOpen

func _ready():
	isLeaderboardOpen = false
	pass

func _input(event):
	if(event.is_action_pressed("escape") && isLeaderboardOpen):
		show_leaderboard()

func show_leaderboard():
	if(!isLeaderboardOpen):
		get_parent().get_node("Leaderboard").show()
	else:
		get_parent().get_node("Leaderboard").hide()
	isLeaderboardOpen = !isLeaderboardOpen
