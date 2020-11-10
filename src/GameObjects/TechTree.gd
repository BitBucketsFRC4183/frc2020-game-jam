extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var tech_costs = {
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

func _on_Tech_pressed(tech_name):
	#Generic method for when a tech is pressed
	# Need to check:
	#	Is tech already unlocked
	#	Is tech the next tier (can't directly research Tier 3)
	print(tech_name)
	
	var can_research = is_tech_valid(tech_name)
	var popup: String
	
	if(can_research):
		popup = "ResearchPopup"
	else:
		popup = "ResearchFailedPopup"
	
	get_node(popup).set_info(tech_name)
	get_node(popup).popup_centered()
	pass

func is_tech_valid(tech):
	var tech_name = tech.substr(0, tech.length() - 1).to_lower()
	var tech_num = int(tech.substr(tech.length() - 1)) - 1
	
	if(PlayerData.new().tech_level[tech_name] + 1 == tech_num):
		return true
	else:
		return false
	pass
