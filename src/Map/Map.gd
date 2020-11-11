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
		if instanced_scene.placeable:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Input.set_default_cursor_shape(Input.CURSOR_FORBIDDEN)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and instanced_scene:
		if instanced_scene.placeable:
			instanced_scene.position =  get_local_mouse_position()
			Signals.emit_signal("game_building_placed", PlayersManager.whoami().num, building_type)
			instanced_scene = null


func get_territories(root: Node = self) -> Array:
	# recursively loop through all nodes in the tree and find all the Territories
	var territories = []
	for node in root.get_children():
		if node is Territory:
			territories.append(node)
		if node.get_child_count() > 0:
			var child_territories = get_territories(node)
			for child_territory in child_territories:
				territories.append(child_territory)
	return territories
