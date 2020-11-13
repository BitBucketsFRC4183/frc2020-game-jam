# each player has data
extends Reference
class_name PlayerData

var network_id: int 						# The player's network id
export var num: int 						# The player number, i.e. player 1, 2, 3...
export var name: String					# The player's name in the game
export var ai_controlled: bool = true		# Is the player AI Controlled?
export var color: Color = Color.black		# The player's color
export var score = 0						# The player's score

# the current resources the player has on hand
var resources = {
	Enums.resource_types.power: 0,
	Enums.resource_types.science: 0,
	Enums.resource_types.raw: 0,
}

# the player's current tech level
var tech_level = {
	"mine": Enums.raw.mine1,
	"power": Enums.power.power1,
	"science": Enums.science.science1,
	"missile": Enums.missile.missile1,
	"laser": Enums.laser.laser1,
	"shield": Enums.shield.shield1
}

# the player's currently selected tech
var selected_tech = ""

# the player's current progress towards researching the tech
var tech_research_progress = 0

func check_research_complete():
	if selected_tech != "":
		var tech_name = selected_tech.substr(0, selected_tech.length() - 1)
		var tech_tier = int(selected_tech.substr(selected_tech.length() - 1, selected_tech.length()))
		var tech_cost = Constants.tech_costs[tech_name][selected_tech]
		if tech_cost <= tech_research_progress:
			research_tech(tech_name, tech_tier)
			tech_research_progress = 0
			selected_tech = ""

func research_tech(name, tier):
	print("Completing Research for " + name + str(tier))
	if(name == "mine"):
		tech_level["mine"] = Enums.raw.mine2 if tier == 2 else Enums.raw.mine3
	elif(name == "power"):
		tech_level["power"] = Enums.power.power2 if tier == 2 else Enums.raw.power3
	elif(name == "science"):
		tech_level["science"] = Enums.science.science2 if tier == 2 else Enums.science.science3
	elif(name == "missile"):
		tech_level["missile"] = Enums.missile.missile2 if tier == 2 else Enums.missile.missile3
	elif(name == "laser"):
		tech_level["laser"] = Enums.laser.laser2 if tier == 2 else Enums.laser.laser3
	elif(name == "shield"):
		tech_level["shield"] = Enums.shield.shield2 if tier == 2 else Enums.shield.shield3

func _init(num: int, name: String, color: Color) -> void:
	._init()
	self.num = num
	self.name = name
	self.color = color

func to_dict() -> Dictionary:
	# convert this player to a dictionary so we can send it over RPC
	return {
		"network_id": network_id,
		"name": name,
		"num": num,
		"ai_controlled": ai_controlled,
		"color": color.to_rgba32(),
		"resources": resources,
		"selected_tech": selected_tech,
		"tech_research_progress": tech_research_progress,
		"tech_level": tech_level,
		"score": score
	}

func from_dict(dict: Dictionary) -> void:
	# update some fields based on this dict
	# if the field isn't present, just keep what we have
	network_id = dict.get("network_id", network_id)
	name = dict.get("name", name)
	num = dict.get("num", num)
	ai_controlled = dict.get("ai_controlled", ai_controlled)
	color = Color(dict.get("color", color.to_rgba32()))
	resources = dict.get("resources", resources)
	selected_tech = dict.get("selected_tech", selected_tech)
	tech_research_progress = dict.get("tech_research_progres", tech_research_progress)
	tech_level = dict.get("tech_level", tech_level)
	score = dict.get("score", score)
