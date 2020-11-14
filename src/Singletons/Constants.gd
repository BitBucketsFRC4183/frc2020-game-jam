extends Node

const seconds_per_day := 3

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

var starting_resources := {
	"Raw": 50,
	"Power": 50,
	"Science": 0
}

var building_costs := {
	"Mine": BuildingCost.new(Enums.resource_types.raw, 15),
	"PowerPlant": BuildingCost.new(Enums.resource_types.raw, 15),
	"ScienceLab": BuildingCost.new(Enums.resource_types.raw, 15),
	"Radar": BuildingCost.new(Enums.resource_types.raw, 25, Enums.resource_types.power, true),
	"Missile": BuildingCost.new(Enums.resource_types.raw, 100),
	"Laser": BuildingCost.new(Enums.resource_types.raw, 50, Enums.resource_types.power, true),
	"Shield": BuildingCost.new(Enums.resource_types.raw, 50, Enums.resource_types.power, true),
}

var tech_costs := {
	"mine": {
		"mine2": 100,
		"mine3": 300
	},
	"power": {
		"power2": 100,
		"power3": 200
	},
	"science": {
		"science2": 200,
		"science3": 400
	},
	"missile": {
		"missile2": 300,
		"missile3": 600
	},
	"laser": {
		"laser2": 250,
		"laser3": 500
	},
	"shield": {
		"shield2": 100,
		"shield3": 300
	}
}

var score_granted := {
	"building_built": 200,
	"research_completed": 500,
	"donated": 750,
	"asteroid_shot": 250,
	"asteroid_deflected": 150,
	"asteroid_destroyed": 250
}

# WARNING! This value can't really just be changed here. We need to add
# * Colors
# * Names
# * Map Territories
const num_players = 5
const random_names = [
	"Bit Buckets",
	"The Buhlian Operators",
	"Javawockies",
	"Blue Alliange",
	"Alumiboti",
	"Blarglefish"
]

