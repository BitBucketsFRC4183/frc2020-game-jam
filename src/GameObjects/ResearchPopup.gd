extends AcceptDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var tech: String
var default_text = "Do you want to research this Tech?\n"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_scale(Vector2(2.0, 2.0))
	set_text(default_text)
	get_ok().set_text("Research!")

func set_popup_properties():
	window_title = tech

func set_info(tech_name):
	tech = tech_name
	print(tech.substr(0, tech.length() - 1))
	var t_name = tech.substr(0, tech.length() - 1).to_lower()
	var cost = Constants.tech_costs[t_name][tech.to_lower()]
	self.set_text(default_text + "\n\nCost: " + str(cost))

func _on_ResearchPopup_confirmed():
	emit_signal("custom_action", tech)
