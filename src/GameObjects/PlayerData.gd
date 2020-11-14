# each player has data
extends Reference
class_name PlayerData

var network_id: int 				# The player's network id
var num: int 						# The player number, i.e. player 1, 2, 3...
var name: String					# The player's name in the game
var ready: bool = true				# Is the player AI Controlled?
var ai_controlled: bool = true		# Is the player AI Controlled?
var color: Color = Color.black		# The player's color
var score = 0						# The player's score

# the current resources the player has on hand
var resources = {
	Enums.resource_types.power: Constants.starting_resources["Power"],
	Enums.resource_types.science: Constants.starting_resources["Science"],
	Enums.resource_types.raw: Constants.starting_resources["Raw"],
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

func add_score(score_event_name):
	score += Constants.score_granted[score_event_name];
	Signals.emit_signal("player_score_changed")

# the player's currently selected tech
var selected_tech = ""

# the player's current progress towards researching the tech
var tech_research_progress = 0

func check_research_complete():
	if selected_tech != "":
		var tech_name = selected_tech.substr(0, selected_tech.length() - 1)
		var tech_tier = int(selected_tech.substr(selected_tech.length() - 1, selected_tech.length()))
		var tech_cost = Constants.tech_costs[tech_name][selected_tech]

		print("Research Progress: " + str(tech_research_progress))
		if tech_cost <= tech_research_progress:
			research_tech(tech_name, tech_tier)
			tech_research_progress = 0
			selected_tech = ""
		else:
			Signals.emit_signal("tech_progress_changed", self)

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

	PlayersManager.whoami().add_score("research_completed")

func can_afford_building(building_name):
	var costs = Constants.building_costs[building_name]
	var cost = costs.cost
	var type1 = costs.type1
	var type2
	if costs.has_type_2:
		type2 = costs.type2
	else:
		type2 = null

	# if we have enough resources for type1, that's fine
	# still go on since we need to check type2
	if resources[type1] >= cost:
		pass
	# not enoguh resources - reutrn
	else:
		return false

	if type2:
		# if we have enough resources for type2 as well
		if resources[type2] >= cost:
			return true
		# not enough resources for type2
		else:
			return false
	# there is no type2, and we already have enoguh for type1
	else:
		return true

func can_donate_amount(resource_type: int, amount:int):
	if resources[resource_type] >= amount:
		return true
	else:
		return false

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
		"ready": ready,
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
	ready = dict.get("ready", ready)
	ai_controlled = dict.get("ai_controlled", ai_controlled)
	color = Color(dict.get("color", color.to_rgba32()))
	resources = dict.get("resources", resources)
	selected_tech = dict.get("selected_tech", selected_tech)
	tech_research_progress = dict.get("tech_research_progres", tech_research_progress)
	tech_level = dict.get("tech_level", tech_level)
	score = dict.get("score", score)
