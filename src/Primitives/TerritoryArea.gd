extends Area2D
class_name TerritoryArea

var buildings_in_area := []


func get_territory():
	return get_child(0)

func get_buildings():
	# if it's already destroyed, don't care about buildings passing through after the fact
	if get_territory().type == Enums.territory_types.destroyed:
		return []

	var all_areas = get_overlapping_areas()
	for a in all_areas:
		if a is GameBuilding:
			buildings_in_area.append(a)

	return buildings_in_area
