extends Node2D

export var own_all = false

var smoke_scene = preload("res://src/VFX/Smoke.tscn")
var instanced_scene = null
var building_type_name: String


func _ready() -> void:
	Signals.connect("game_building_selected", self, "_on_game_building_selected")
	Signals.connect("game_building_cancelled", self, "_on_game_building_cancelled")
	Signals.connect("game_building_placed", self, "_on_game_building_placed")
	Signals.connect("asteroid_impact", self, "_on_asteroid_impact")


	if own_all:
		var territories = get_territories()
		for territory in territories:
			if territory is Territory:
				territory.set_territory_owner(1)

	# init our building manager. On the client and server these should be the same
	var buildings = get_buildings()
	BuildingsManager.init_buildings(buildings)

func _on_game_building_selected(scene_path, building):
	instanced_scene = load(scene_path).instance()
	instanced_scene.newly_spawned = true
	instanced_scene.player_num = PlayersManager.whoami().num
	instanced_scene.building_name = building
	add_child(instanced_scene)
	building_type_name = building

func _on_game_building_cancelled():
	if instanced_scene:
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
			$Click.play(.2)
			# emit a signal so it will be placed
			var position := get_local_mouse_position()
			var building_id := BuildingsManager.get_next_id()
			Signals.emit_signal("game_building_placed", building_id, instanced_scene.player_num, building_type_name, position)
			RPC.send_game_building_placed(building_id, building_type_name, position)

			# cancel our placement
			_on_game_building_cancelled()

func _on_game_building_placed(building_id: String, player_num: int, building_type_name: String, position: Vector2):
	var building_scene = load(Utils._get_scene_path_for_building_type(building_type_name)).instance()
	building_scene.player_num = player_num
	building_scene.position =  position
	building_scene.building_id = building_id
	building_scene.activate()
	add_child(building_scene)

	PlayersManager.get_player(player_num).add_score("building_built")
	BuildingsManager.add_building(building_scene)

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

func get_buildings(root: Node = self) -> Array:
	# recursively loop through all nodes in the tree and find all the GameBuildings
	var buildings = []
	for node in root.get_children():
		if node is GameBuilding:
			buildings.append(node)
		if node.get_child_count() > 0:
			var child_buildings = get_buildings(node)
			for child_building in child_buildings:
				buildings.append(child_building)
	return buildings


func _on_asteroid_impact(asteroid_id, impact_point, explosion_radius):
	var area = Area2D.new()

	var shape = CircleShape2D.new()
	shape.set_radius(explosion_radius)

	var collision = CollisionShape2D.new()
	collision.set_shape(shape)

	area.add_child(collision)

	area.global_position = impact_point
	call_deferred("impact_deferred", area)

func impact_deferred(area: Area2D) -> void:
	add_child(area)
	area.connect("area_entered", self, "_on_impact_registered", [area])


func _on_impact_registered(target, area):
	var areas = area.get_overlapping_areas()
	for node in areas:
		if node is TerritoryArea:

			# delete buildings on now-destroyed territories
			for b in node.get_buildings():
				b.queue_free()
			# smoke fx
			var smoke = smoke_scene.instance()
			smoke.position = area.position
			add_child(smoke)
			$AsteroidTerritoryStrike.play()

			if node.get_child_count() > 0:
				var child = node.get_child(0)
				if child is Territory:
					child.set_type(Enums.territory_types.destroyed)
					Signals.emit_signal("territory_destroyed", child)
	area.queue_free()


