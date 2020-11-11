# each player has data
extends Resource
class_name PlayerData

var id: int 			# The player's network id
var num: int 		# The player number, i.e. player 1, 2, 3...
var name: String		# The player's name in the game
var score = 100

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
