tool
extends TextureButton

export (Enums.game_buildings) var building = Enums.game_buildings.Mine
var building_name

signal selected(building)

func _ready() -> void:
	match building:
		Enums.game_buildings.Mine:
			texture_normal = load("res://assets/icons/Mine.png")
		Enums.game_buildings.PowerPlant:
			texture_normal = load("res://assets/icons/Power Plant.png")
		Enums.game_buildings.ScienceLab:
			texture_normal = load("res://assets/icons/Lab.png")
		Enums.game_buildings.Radar:
			texture_normal = load("res://assets/icons/Radar.png")
		Enums.game_buildings.Missile:
			texture_normal = load("res://assets/icons/Missile.png")
		Enums.game_buildings.Laser:
			texture_normal = load("res://assets/icons/Laser.png")
		Enums.game_buildings.Shield:
			texture_normal = load("res://assets/icons/Shield.png")

	building_name = Enums.game_buildings.keys()[building]
	$Name.text = building_name
	get_cost()

	Signals.connect("player_data_updated", self, "_on_player_data_updated")


func _on_GameBuildingButton_pressed() -> void:
	# pass the name of the building to be used to instance the scene (used to check hitboxes)
	emit_signal("selected", building_name)
	$ClickSound.play(.2)

func get_cost():
	var cost_item = Constants.building_costs[building_name]

	var cost_num = cost_item.cost
	var cost_name_1 = Enums.resource_types.keys()[cost_item.type1].capitalize()
	var cost_name_2 = ""

	if cost_item.has_type_2:
		cost_name_2 = Enums.resource_types.keys()[cost_item.type2].capitalize()

	var cost_string = ""
	if cost_item.has_type_2:
		cost_string = "%s, %s: %s" % [cost_name_1, cost_name_2, cost_num]
	else:
		cost_string = "%s: %s" % [cost_name_1.capitalize(), cost_num]

	$Cost.text = cost_string

func check_can_afford(p):
	var cost_item = Constants.building_costs[building_name]

	if p.resources[cost_item.type1] >= cost_item.cost:
		if cost_item.has_type_2:
			# has enough for both types
			if p.resources[cost_item.type2] > cost_item.cost:
				return true
			# not enough for type2
			else:
				return false
		# enough for type1, typ2 doesnt exist
		else:
			return true
	# not enough for type1
	else:
		return false

func _on_player_data_updated(p):
	if check_can_afford(p):
		self.modulate= Color.white
	else:
		modulate = Color.darkgray

