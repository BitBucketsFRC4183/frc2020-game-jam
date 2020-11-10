extends MarginContainer

var scene_path: String

func _ready() -> void:
	Signals.connect("game_building_placed", self, "restore_cursor")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		restore_cursor("")
		Signals.emit_signal("game_building_cancelled")

# parameter is just there so that the signal works
func restore_cursor(building):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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




