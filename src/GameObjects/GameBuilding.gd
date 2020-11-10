class_name GameBuilding
extends Area2D

var placeable := false

# set to true when we enter an area which is NOT a territory
# ie, it is another building
var in_another_area := false
var newly_spawned := false

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_area_entered(area):
	if not newly_spawned:
		return

	# if we enter another territory, validate the territory
	if area.is_in_group("territories"):
		check_valid_territory(area)
	# otherwise, we're in another building
	else:
		in_another_area = true
		placeable = false

func _on_area_exited(area):
	if not newly_spawned:
		return

	# if we just left a territory, set placeable to false
	# the new territory will be validated in _on_area_entered
#	if area.is_in_group("territories"):
#			placeable = false

	if in_another_area:
		# if we're touching another building and just left a territory,
		# we're still in another building
		# so we can't place
		if area.is_in_group("territories"):
			placeable = false
		else:
			# we just left the other area we're in
			in_another_area = false
			# check to see if we're in a territory
			# if we are, validate the territory
			# we need this because if we exit the building to a territory,
			# it won't call an "area_entered" since we never left the territory area
			# that's why we check manually
			for area in get_overlapping_areas():
				if area.is_in_group("territories"):
					check_valid_territory(area)
#	else:
#		if area.is_in_group("territories"):
#			placeable = false

func check_valid_territory(area):
	# if the area is a resource territory AND
	# we are not touching another building, placeable
	if area.get_child(0).type == Enums.territory_types.resource and not in_another_area:
		placeable = true
	# if either of those are false, say no
	else:
		placeable = false

