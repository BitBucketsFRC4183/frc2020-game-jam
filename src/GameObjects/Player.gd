extends Node2D

var resources = {
	"power": 100,
	"science": 100,
	"raw": 20,
	"missiles": 5,
	"lasers": 10
}

var score = 100

enum raw_enum {mine1, mine2, mine3}
enum energy_enum {coal, solar, nuclear}
enum science_enum {science1, science2, science2}
enum missile_enum {missile1, missile2, missile3}
enum laser_enum {laser1, laser2, laser3}
enum shield_enum {shield1, shield2, shield3}

var tech = {
	"mine": raw_enum.mine1,
	"energy": energy_enum.coal,
	"science": science_enum.science1,
	"missile": missile_enum.missile1,
	"laser": laser_enum.laser1,
	"shield": shield_enum.shield1
}
