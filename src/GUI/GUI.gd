extends Control

var Player = preload("res://src/GameObjects/Player.tscn")
var PlayerResources = preload("res://src/Map/PlayerResources.tscn")

var scene_path: String

func _ready() -> void:
	Signals.connect("game_building_placed", self, "restore_cursor")

	# The server sends us a day update and our client emits a day_passed signal
	Signals.connect("day_passed", self, "_on_day_passed")

	var container = $Stats

	for player_data in PlayersManager.players:
		var player_node = Player.instance()
		var player_resources_node = PlayerResources.instance()

		player_node.data = player_data
		player_resources_node.player = player_node
		container.add_child(player_node)
		container.add_child(player_resources_node)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		restore_cursor("", "")
		Signals.emit_signal("game_building_cancelled")

# parameters are just there so that the signal works
func restore_cursor(network_data, building):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_day_passed(day: int) -> void:
	$Stats/HBoxContainer/Day.text = "%d" % day

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




