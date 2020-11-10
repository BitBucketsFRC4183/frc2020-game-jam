extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tech: String

# Called when the node enters the scene tree for the first time.
func _ready():
	get_ok().visible = false	
	add_button("Research Tech", true)
	add_cancel("Cancel")
	
func set_popup_properties():
	window_title = tech
	
func set_info(tech_name):
	tech = tech_name
