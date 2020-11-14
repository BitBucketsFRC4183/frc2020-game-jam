extends Node2D
class_name Player

var data: PlayerData


func _ready() -> void:
	Signals.connect("resource_generated", self, "_on_resource_generated")
	Signals.connect("game_building_placed", self, "_on_game_building_placed")
	Signals.connect("player_give_resources", self, "_on_player_give_resources")

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
		Signals.emit_signal("player_data_updated", data)

func _on_game_building_placed(player_num, building_type_name, position):
	if data.num == player_num:
		var building_cost = Constants.building_costs[building_type_name]
		data.resources[building_cost.type1] -= building_cost.cost
		if building_cost.has_type_2:
			data.resources[building_cost.type2] -= building_cost.cost
		Signals.emit_signal("player_data_updated", data)

func _on_player_give_resources(source_player_num: int, dest_player_num: int, resource_type: int, amount:int):
	if not PlayersManager.whoami().can_donate_amount(resource_type, amount):
		return

	if source_player_num == data.num:
		# I am the giver. I lose resources
		data.resources[resource_type] -= amount
		print_debug("(%s) gave player %s gave me %s %s resources!" % [data.name, dest_player_num, amount, Enums.resource_types.keys()[resource_type]])
		Signals.emit_signal("player_data_updated", data)
		
		PlayersManager.whoami().score += Constants.score_granted["donated"]
	elif dest_player_num == data.num:
		# I am the receiver. I gain resources
		data.resources[resource_type] += amount
		print_debug("(%s) player %s gave me %s %s resources!" % [data.name, source_player_num, amount, Enums.resource_types.keys()[resource_type]])
		Signals.emit_signal("player_data_updated", data)

