extends GameBuilding

export (Enums.resource_types) var resource_type = Enums.resource_types.EXCEPTION
export var resource_amt := -1

# the player number that owns the building
var building_owner = 1

func _ready() -> void:
	Signals.connect("day_passed", self, "_on_day_passed")

	is_defense_building = false
	is_resource_building = true

func _on_day_passed(day: int):
	assert(resource_type != Enums.resource_types.EXCEPTION)
	assert(resource_amt != -1)
	
	if(resource_type == Enums.resource_types.science):
		PlayersManager.whoami().tech_research_progress += resource_amt
		PlayersManager.whoami().check_research_complete()

	var resource_info = [resource_type, resource_amt]
	Signals.emit_signal("resource_generated", player_num, resource_info)
