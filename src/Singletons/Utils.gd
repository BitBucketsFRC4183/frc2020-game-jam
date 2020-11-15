extends Node

func _get_scene_path_for_building_type(building_type_name: String) -> String:
	match building_type_name:
		"Mine":
			return "res://src/GameObjects/ResourceBuildings/Mine.tscn"
		"PowerPlant":
			return "res://src/GameObjects/ResourceBuildings/PowerPlant.tscn"
		"ScienceLab":
			return "res://src/GameObjects/ResourceBuildings/ScienceLab.tscn"
		"Radar":
			return "res://src/GameObjects/DefenseBuildings/Radar.tscn"
		"Missile":
			return "res://src/GameObjects/DefenseBuildings/Missile.tscn"
		"Laser":
			return "res://src/GameObjects/DefenseBuildings/Laser.tscn"
		"Shield":
			return "res://src/GameObjects/DefenseBuildings/Shield.tscn"
	printerr("Tried to find a scene path for an unknown building_type_name %s" % building_type_name)
	return ""


func has_tech(tech_name: String, p: PlayerData):
	var name = tech_name.substr(0, tech_name.length() - 1)
	var tier = int(tech_name.substr(tech_name.length() - 1, tech_name.length())) - 1
	return p.tech_level[name.to_lower()] >= tier

func can_research(tech_name, p: PlayerData):
	# Need to check:
	#	Is tech already unlocked
	#	Is tech the next tier (can't directly research Tier 3)
	return is_tech_valid(tech_name, p) && not is_player_researching(p) && not has_tech(tech_name, p)

func research_tech(tech: String, p: PlayerData):
	p.selected_tech = tech.to_lower()
	if not get_tree().is_network_server():
		# tell the server we are researching this
		RPC.send_player_select_tech(p.selected_tech)

	var science = p.resources[Enums.resource_types.science]
	var t_name = tech.to_lower().substr(0, tech.length() - 1).to_lower()
	var cost = Constants.tech_costs[t_name][tech.to_lower()]

	p.tech_research_progress = science if science < cost else cost
	p.resources[Enums.resource_types.science] -= science if science < cost else cost

func is_player_researching(p: PlayerData):
	return p.selected_tech != ""

func is_tech_valid(tech, p: PlayerData):
	var tech_name = tech.substr(0, tech.length() - 1).to_lower()
	var tech_num = int(tech.substr(tech.length() - 1)) - 1

	if(tech_name == "missile"):
		return false

	if tech_num - p.tech_level[tech_name] == 1:
		return true
	else:
		return false
	pass

func player_message_from_dict(dict: Dictionary) -> PlayerMessage:
	return PlayerMessage.new(dict.get("num", 1), dict.get("message", ""))
