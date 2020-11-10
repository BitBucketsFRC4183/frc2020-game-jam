extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tech: String

# Called when the node enters the scene tree for the first time.
func _ready():
	var tech_info = "NYI" #Add this later
	get_ok().visible = false	
	dialog_text = "Do you want to research this Tech? \nTech Info: " + tech_info
	add_button("Research Tech", true)
	add_cancel("Cancel")
	
func set_popup_properties():
	window_title = tech
	
func set_info(tech_name):
	tech = tech_name
