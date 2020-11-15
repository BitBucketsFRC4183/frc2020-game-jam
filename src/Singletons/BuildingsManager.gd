extends Node

# the number of buildings this client has built
var building_count := 0

# a set of GameBuilding instances by id
var buildings_by_id = {}

func _ready():
	pass

func get_next_id() -> String:
	# Get a new id for a placed building, this is our network id combined with the count so we don't conflict with other clients
	building_count += 1
	return str(get_tree().get_network_unique_id()) + "-" + str(building_count)

func init_buildings(buildings: Array, init_ids = true, id_prefix = "1-"):
	# init the building manager with our starting buildings
	# if this is a new game, all buildings are id'd by the server, so we need to keep them
	# in sync. Ideally, we'd pass these building datatypes over the wire before a game starts, but 
	# in the interests of time, we'll just make them match up
	for building in buildings:
		var building_id = building.building_id
		if init_ids:
			building_count += 1
			building_id = id_prefix + str(building_count)
		buildings_by_id[building_id] = building

func add_building(building_scene: GameBuilding):
	buildings_by_id[building_scene.building_id] = building_scene

