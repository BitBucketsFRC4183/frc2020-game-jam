# each player has data
extends Reference
class_name PlayerData

var network_id: int 						# The player's network id
export var num: int 						# The player number, i.e. player 1, 2, 3...
export var name: String						# The player's name in the game
export var ai_controlled: bool = true		# Is the player AI Controlled?
export var color: Color = Color.black		# The player's color
export var score = 0

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
var selected_tech = "mine"

func _init(num: int, name: String, color: Color) -> void:
	._init()
	self.num = num
	self.name = name
	self.color = color
