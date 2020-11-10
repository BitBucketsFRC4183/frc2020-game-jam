extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Tech_pressed(tech_name):
	#Generic method for when a tech is pressed
	# Need to check:
	#	Is tech already unlocked
	#	Is tech the next tier (can't directly research Tier 3)
	print(tech_name)
	
	var can_research = true
	var popup: String
	
	#Not complete, still testing
	is_tech_valid(tech_name)
	
	if(can_research):
		popup = "ResearchPopup"
	else:
		popup = "ResearchFailedPopup"
	
	get_node(popup).set_info(tech_name)
	get_node(popup).popup_centered()
	pass

func is_tech_valid(tech):
	var tech_name = tech.substr(0, tech.length() - 1).to_lower()
	var tech_num = int(tech.substr(tech.length() - 1))
	
	print(tech_name)
	print(tech_num)
	pass
