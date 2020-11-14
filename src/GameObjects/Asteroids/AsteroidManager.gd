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
var num_asteroids = 0

func _ready():
	Signals.connect("asteroid_impact", self, "_on_asteroid_impact")
	Signals.connect("asteroid_destroyed", self, "_on_asteroid_destroyed")
	Signals.connect("server_started", self, "_on_server_started")
	# clients listen for asteroid_incoming messages
	Signals.connect("asteroid_incoming", self, "_on_asteroid_incoming")

	if get_tree().is_network_server() && Server.started:
		# if we are network server and the server is already started, start the timer
		$Timer.start()
		Signals.emit_signal("asteroid_wave_timer_reset", $Timer.time_left)

func _on_server_started():
	if get_tree().is_network_server():
		print("Starting asteroid waves")
		# only start the timer to spanw new waves if we are the server
		$Timer.start()
		Signals.emit_signal("asteroid_wave_timer_reset", $Timer.time_left)

func _on_Timer_timeout():
	wave += 1
	if wave < waves or waves == -1:
		$Timer.start(base_wave_time * rand_range(0.25,2))
		Signals.emit_signal("asteroid_wave_timer_reset", $Timer.time_left)
	if wave == waves:
		final_wave()

	asteroid_count += wave + asteroid_quantity_modifier

	if asteroid_count > max_count:
			asteroid_count = max_count
	territories.shuffle()

	for i in range(asteroid_count):
		var asteroid_strength = rand_range(0, wave * asteroid_strength_multiplier)
		var asteroid = _get_asteroid_instance(asteroid_strength)

		# give each new asteroid an incrementing id
		# so we can uniquely identify them
		asteroid.id = num_asteroids
		num_asteroids += 1

		asteroid.global_position = territories[i].center_global
		active_asteroids += 1
		add_child(asteroid)
		# after this asteroid is setup, send it to the clients
		call_deferred("send_asteroid", asteroid.global_position, asteroid_strength, asteroid)

func _get_asteroid_instance(asteroid_strength: int):
	# create a new asteroid scene from an asteroid_strength
	if asteroid_strength > max_strength:
		asteroid_strength = max_strength
	if asteroid_strength < 15:
		return asteroid_small.instance()
	elif asteroid_strength < 30:
		return asteroid_medium.instance()
	else:
		return asteroid_large.instance()


func send_asteroid(position: Vector2, asteroid_strength: int, asteroid):
	RPC.send_asteroid(position, asteroid_strength, asteroid.get_attributes())


func _on_asteroid_incoming(position: Vector2, asteroid_strength, attributes: Dictionary):
	if not get_tree().is_network_server():
		# only clients care about this method
		# they spawn
		var asteroid = _get_asteroid_instance(asteroid_strength)
		asteroid.global_position = position
		active_asteroids += 1
		add_child(asteroid)
		call_deferred("_update_asteroid_after_spawn", asteroid, attributes)

func _update_asteroid_after_spawn(asteroid, attributes: Dictionary):
	asteroid.from_attributes(attributes)

func _on_asteroid_impact(asteroid_id, impact_point, explosion_radius):
	remove_active_asteroid()

func _on_asteroid_destroyed(position, size):
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
