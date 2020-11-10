extends MarginContainer

var scene_path: String

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Signals.emit_signal("game_building_cancelled")

func _on_GameBuildingButton_selected(building) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	var dir = Directory.new()
	var start_path = "res://src/GameObjects/"
	var end_path = building + ".tscn"

	scene_path = start_path + "DefenseBuildings/" + end_path

	if dir.file_exists(scene_path):
		Signals.emit_signal("game_building_selected", scene_path)

	elif dir.file_exists(start_path + "ResourceBuildings/" + end_path):
		scene_path = start_path + "ResourceBuildings/" + end_path
		Signals.emit_signal("game_building_selected", scene_path)




