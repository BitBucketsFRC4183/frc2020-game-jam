extends Control

var scene_path: String
var days_until_next_asteroid := 0 setget set_days_until_next_asteroid

func _ready() -> void:
	Signals.connect("game_building_placed", self, "restore_cursor")

	# The server sends us a day update and our client emits a day_passed signal
	Signals.connect("day_passed", self, "_on_day_passed")

	# update our asteroid incoming message
	Signals.connect("asteroid_wave_timer_reset", self, "_on_asteroid_wave_timer_reset")

	# update score gui node
	Signals.connect("player_score_changed", self, "update_player_score_label")

	var player = PlayersManager.whoami()
	$TopMenu/Left/HBoxContainer/Score.label = "%s Score" % player.name
	$TopMenu/Left/HBoxContainer/Score.modulate = player.color

	var other_player_num := 1
	for i in range(PlayersManager.players.size()):
		var players := PlayersManager.players as Array
		var other_player := PlayersManager.players[i] as PlayerData
		if player.num != other_player.num:
			var node_path := "BottomMenu/Right/VBoxContainer/OtherPlayerStats/VBoxContainer/PlayerGive%s" % (other_player_num)
			var give_node = get_node(node_path)
			give_node.player_num = other_player.num
			give_node.player_name = other_player.name
			other_player_num += 1


func _on_day_passed(day: int) -> void:
	$TopMenu/Right/HBoxContainer/Days.value = "%d" % day
	set_days_until_next_asteroid(days_until_next_asteroid - 1)

func update_player_score_label() -> void:
	print("Updating score: " + str(PlayersManager.whoami().score))
	$TopMenu/Left/HBoxContainer/Score.set_value(str(PlayersManager.whoami().score))

func _on_asteroid_wave_timer_reset(time_left: float):
	# this gives us the time left in seconds
	set_days_until_next_asteroid((time_left / Constants.seconds_per_day) as int)


func set_days_until_next_asteroid(value: int):
	if value >= 0:
		days_until_next_asteroid = value
	else:
		days_until_next_asteroid = 0
	$TopMenu/Center/VBoxContainer/HeaderLabel.text = "Asteroids incoming in %s days!" % days_until_next_asteroid


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		restore_cursor(0, Enums.game_buildings.Mine, Vector2.ZERO)
		Signals.emit_signal("game_building_cancelled")


# parameters are just there so that the signal works
func restore_cursor(player_num, building_type_name, position):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _on_GameBuildingButton_selected(building) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	var dir = Directory.new()
	var start_path = "res://src/GameObjects/"
	var end_path = building + ".tscn"

	scene_path = start_path + "DefenseBuildings/" + end_path

	if dir.file_exists(scene_path):
		Signals.emit_signal("game_building_selected", scene_path, building)

	elif dir.file_exists(start_path + "ResourceBuildings/" + end_path):
		scene_path = start_path + "ResourceBuildings/" + end_path
		# pass scene path as well as building name
		Signals.emit_signal("game_building_selected", scene_path, building)




