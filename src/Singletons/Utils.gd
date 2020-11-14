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

func player_message_from_dict(dict: Dictionary) -> PlayerMessage:
	return PlayerMessage.new(dict.get("num", 1), dict.get("message", ""))
