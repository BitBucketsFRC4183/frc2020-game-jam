extends Node2D

var instanced_scene = null

func _ready() -> void:
	Signals.connect("game_building_selected", self, "_on_game_building_selected")
	Signals.connect("game_building_cancelled", self, "_on_game_building_cancelled")

func _on_DaysTimer_timeout() -> void:
	Signals.emit_signal("day_passed")

func _on_game_building_selected(scene_path):
	instanced_scene = load(scene_path).instance()
	instanced_scene.newly_spawned = true
#	instanced_scene.visible = false
	add_child(instanced_scene)
#	instanced_scene.get_node("Sprite").scale = Vector2(1, 1)

func _on_game_building_cancelled():
	instanced_scene.queue_free()
	instanced_scene = null

func _process(delta: float) -> void:
	if instanced_scene:
		instanced_scene.position =  get_local_mouse_position()
