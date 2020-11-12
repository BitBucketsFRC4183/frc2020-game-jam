extends Node2D

export var waves = 50
export var asteroid_quantity_modifier = 1
export var asteroid_strength_multiplier = 1
export var max_strength = 50
export var max_count = 50
export var base_wave_time = 60

var wave = 0
var asteroid_count = 1
var territories = []

func _on_Timer_timeout():
	if wave < waves or waves == -1:
		wave += 1
		$Timer.start(base_wave_time * rand_range(0.25,2))
	
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
			asteroid = load("res://src/GameObjects/Asteroids/FallingAsteroidSmall.tscn").instance()
		elif asteroid_strength < 30:
			asteroid = load("res://src/GameObjects/Asteroids/FallingAsteroidMedium.tscn").instance()
		else:
			asteroid = load("res://src/GameObjects/Asteroids/FallingAsteroidSmall.tscn").instance()
		asteroid.global_position = territories[i].global_position
		add_child(asteroid)
