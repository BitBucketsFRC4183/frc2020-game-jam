extends Node2D

var resources = {
	"power": 100,
	"science": 100,
	"raw": 20,
	"missiles": 5,
	"lasers": 10
}

var score = 100

var tech = {
	"mine": Enums.raw_enum.mine1,
	"energy": Enums.energy_enum.power1,
	"science": Enums.science_enum.science1,
	"missile": Enums.missile_enum.missile1,
	"laser": Enums.laser_enum.laser1,
	"shield": Enums.shield_enum.shield1
}
