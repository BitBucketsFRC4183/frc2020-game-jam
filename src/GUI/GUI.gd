extends Control

var scene_path: String
var days_until_next_asteroid := 0 setget set_days_until_next_asteroid

func _ready() -> void:
	Signals.connect("game_building_placed", self, "restore_cursor")

	# The server sends us a day update and our client emits a day_passed signal
	Signals.connect("day_passed", self, "_on_day_passed")
	
	# update our asteroid incoming message
	Signals.connect("asteroid_wave_timer_reset", self, "_on_asteroid_wave_timer_reset")
	
	var player = PlayersManager.whoami()
	$TopMenu/Left/HBoxContainer/Score.label = "%s Score" % player.name
	$TopMenu/Left/HBoxContainer/Score.modulate = player.color


func _on_day_passed(day: int) -> void:
	$TopMenu/Right/HBoxContainer/Days.value = "%d" % day
	set_days_until_next_asteroid(days_until_next_asteroid - 1)


func _on_asteroid_wave_timer_reset(time_left: float):
	# this gives us the time left in seconds
	set_days_until_next_asteroid((time_left / Constants.seconds_per_day) as int)


func set_days_until_next_asteroid(value: int):
	days_until_next_asteroid = value
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




