#class_name ResourceBuilding
extends Area2D

enum resource_types {power, science, raw, EXCEPTION}

export (resource_types) var resource_type = resource_types.EXCEPTION
export var resource_amt := -1

var placeable := false
var placeable_before_entering_another_area
var in_another_area := false
var newly_spawned := false

func _ready() -> void:
	Signals.connect("day_passed", self, "_on_day_passed")
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_day_passed():
	assert(resource_type != resource_types.EXCEPTION)
	assert(resource_amt != -1)

	var resource_info = [resource_type, resource_amt]
	Signals.emit_signal("resource_generated", resource_info)

func _on_area_entered(area):
	if not newly_spawned:
		return

	if area.is_in_group("territories"):
		check_valid_territory(area)
	else:
		in_another_area = true
		placeable = false

func _on_area_exited(area):
	if not newly_spawned:
		return

	if in_another_area:
		if area.is_in_group("territories"):
			placeable = false
		else:
			in_another_area = false
			for area in get_overlapping_areas():
				if area.is_in_group("territories"):
					check_valid_territory(area)

func check_valid_territory(area):
	if area.get_child(0).type == Enums.territory_types.resource and not in_another_area:
		placeable = true
	else:
		placeable = false
