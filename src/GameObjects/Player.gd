extends Node2D
class_name Player

onready var data: PlayerData = PlayerData.new()

func _ready() -> void:
	Signals.connect("resource_generated", self, "_on_resource_generated")
	Signals.connect("game_building_placed", self, "_on_game_building_placed")

var resources = {
	Enums.resource_types.power: 100,
	Enums.resource_types.science: 100,
	Enums.resource_types.raw: 20,
}

var stats = {
	"missiles": 5,
	"lasers": 10
}

var score = 100

var tech = {
	"mine": Enums.raw.mine1,
	"power": Enums.power.power1,
	"science": Enums.science.science1,
	"missile": Enums.missile.missile1,
	"laser": Enums.laser.laser1,
	"shield": Enums.shield.shield1
}

func _on_resource_generated(res_list):
	resources[res_list[0]] += res_list[1]
	RPC.send_player_updated(data)

func _on_game_building_placed(building):
	var building_cost = Constants.building_costs[building]
	resources[building_cost.type1] -= building_cost.cost
	if building_cost.has_type_2:
		resources[building_cost.type2] -= building_cost.cost
