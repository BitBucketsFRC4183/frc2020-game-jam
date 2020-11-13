extends Node2D

export var waves = 50
export var asteroid_quantity_modifier = 1
export var asteroid_strength_multiplier = 1
export var max_strength = 50
export var max_count = 50
export var base_wave_time = 60

var asteroid_small = preload("res://src/GameObjects/Asteroids/FallingAsteroidSmall.tscn")
var asteroid_medium = preload("res://src/GameObjects/Asteroids/FallingAsteroidMedium.tscn")
var asteroid_large = preload("res://src/GameObjects/Asteroids/FallingAsteroidLarge.tscn")
var dwarf_planet = preload("res://src/GameObjects/Asteroids/FallingDwarfPlanet.tscn")

var wave = 0
var asteroid_count = 1
var territories = []
var active_asteroids = 0

func _ready():
	Signals.connect("asteroid_impact", self, "_on_asteroid_impact")

func _on_Timer_timeout():
	wave += 1
	if wave < waves or waves == -1:
		$Timer.start(base_wave_time * rand_range(0.25,2))
	if wave == waves:
		final_wave()

	asteroid_count += wave + asteroid_quantity_modifier

	if asteroid_count > max_count:
			asteroid_count = max_count
	territories.shuffle()

	for i in range(asteroid_count):
		var asteroid_strength = rand_range(0, wave * asteroid_strength_multiplier)
		var asteroid

		if asteroid_strength > max_strength:
			asteroid_strength = max_strength
		if asteroid_strength < 15:
			asteroid = asteroid_small.instance()
		elif asteroid_strength < 30:
			asteroid = asteroid_medium.instance()
		else:
			asteroid = asteroid_large.instance()
		asteroid.global_position = territories[i].center_global
		active_asteroids += 1
		add_child(asteroid)

func _on_asteroid_impact(impact_point, explosion_radius):
	remove_active_asteroid()

func final_wave():
	var boss = dwarf_planet.instance()
	boss.global_position = territories[asteroid_count + 1].center_global
	active_asteroids += 1
	add_child(boss)

func remove_active_asteroid():
	active_asteroids -= 1
	if wave == waves and active_asteroids <= 0:
		Signals.emit_signal("final_wave_complete")
