extends Node2D

var instanced_scene = null
var building_type

func _ready() -> void:
	Signals.connect("game_building_selected", self, "_on_game_building_selected")
	Signals.connect("game_building_cancelled", self, "_on_game_building_cancelled")

func _on_game_building_selected(scene_path, building):
	instanced_scene = load(scene_path).instance()
	instanced_scene.newly_spawned = true
	add_child(instanced_scene)
	building_type = building

func _on_game_building_cancelled():
	instanced_scene.queue_free()
	instanced_scene = null

func _process(delta: float) -> void:
	if instanced_scene:
		instanced_scene.position =  get_local_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and instanced_scene:
		if instanced_scene.placeable:
			instanced_scene.position =  get_local_mouse_position()
			Signals.emit_signal("game_building_placed", building_type)
			instanced_scene = null

