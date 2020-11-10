extends Node


class BuildingCost:
	var type1: int
	var cost: int
	var type2: int
	var has_type_2: bool

	func _init(type1: int, cost: int, type2 := -1, has_type_2 := false):
		self.type1 = type1
		self.cost = cost
		self.type2 = type2
		self.has_type_2 = has_type_2


var building_costs := {
	"Mine": BuildingCost.new(Enums.resource_types.raw, 10),
	"PowerPlant": BuildingCost.new(Enums.resource_types.power, 10),
	"ScienceLab": BuildingCost.new(Enums.resource_types.science, 10),
	"Radar": BuildingCost.new(Enums.resource_types.power, 10, Enums.resource_types.science, true),
	"Missile": BuildingCost.new(Enums.resource_types.raw, 10, Enums.resource_types.science, true),
	"Laser": BuildingCost.new(Enums.resource_types.raw, 10, Enums.resource_types.power, true),
	"Shield": BuildingCost.new(Enums.resource_types.power, 10, Enums.resource_types.science, true),
}
