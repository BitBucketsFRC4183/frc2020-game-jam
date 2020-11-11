extends Node2D
class_name Player

signal player_data_changed(data)

var data: PlayerData


func _ready() -> void:
	Signals.connect("resource_generated", self, "_on_resource_generated")
	Signals.connect("game_building_placed", self, "_on_game_building_placed")


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

func _on_resource_generated(player_num: int, res_list):
	if data.num == player_num:
		data.resources[res_list[0]] += res_list[1]
		emit_signal("player_data_changed", data)

func _on_game_building_placed(player_num, building_type):
	if data.num == player_num:
		var building_cost = Constants.building_costs[building_type]
		data.resources[building_cost.type1] -= building_cost.cost
		if building_cost.has_type_2:
			data.resources[building_cost.type2] -= building_cost.cost
		emit_signal("player_data_changed", data)
