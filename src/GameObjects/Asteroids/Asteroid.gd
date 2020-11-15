extends Node2D

export var base_speed = 100
export var explosion_radius = 64
export var base_distance = 1000
export var max_health = 100
export var size = 0

onready var distance = base_distance * rand_range(0.75,3)
onready var speed = base_speed * rand_range(0.75,1.25)
onready var impact_point = $ImpactPoint
onready var asteroid = $Asteroid
onready var health = max_health
var impact_vector = Vector2.ZERO
var destroyed = false

# the id of this asteroid. Used for keeping asteroids in sync over
# the network
var id: int

func _ready():
	_setup_initial_state()
	if not get_tree().is_network_server():
		# if we aren't the server, we have to listen to position updates and impact
		# events from the server
		Signals.connect("asteroid_position_updated", self, "_on_asteroid_position_updated")
		Signals.connect("asteroid_impact", self, "_on_asteroid_impact")
		Signals.connect("asteroid_destroyed", self, "_on_asteroid_destroyed")


func _setup_initial_state():
	asteroid.position += (Vector2(1,-1) * distance)
	impact_vector = (impact_point.position - asteroid.position).normalized()

func _physics_process(delta):
	update_asteroid_position(asteroid.position + (impact_vector * speed * delta))
	# only the server updates asteroids
	# then it sends the new position to each client
	if get_tree().is_network_server():
		RPC.send_asteroid_position_update(id, asteroid.position)

func _on_asteroid_position_updated(asteroid_id: int, position: Vector2):
	# Server messages cause this signal to be raised
	if asteroid_id == id:
		update_asteroid_position(position)

func update_asteroid_position(position: Vector2):
	asteroid.position = position
	# let any interested parties know how long we have left
	var distance_remaining: float = (impact_point.position - asteroid.position).length()
	Signals.emit_signal("asteroid_time_estimate", id, size, distance_remaining / speed)

func _on_ImpactPoint_area_entered(area):
	if get_tree().is_network_server():
		# only detect collisions if we are the server
		if area == asteroid:
			impact()

func impact():
	var areas = impact_point.get_overlapping_areas()
	for area in areas:
		if area is ShieldArea:
			if area.active:
				var damage = health
				health -= area.health
				area.damage(damage)
				if health <= 0:
					destroy()
	if not destroyed:
		Signals.emit_signal("asteroid_impact", id, impact_point.global_position, explosion_radius)
		RPC.send_asteroid_impact(id, impact_point.global_position, explosion_radius)
		queue_free()

func destroy():
	if size == 3:
		Signals.emit_signal("dwarf_planet_destroyed")
	destroyed = true
	Signals.emit_signal("asteroid_destroyed", id, global_position, size)
	RPC.send_asteroid_destroyed(id, global_position, size)
	queue_free()

func damage(damage):
	health -= damage
	if health <= 0:
		destroy()

func _on_asteroid_impact(asteroid_id: int, position: Vector2, explosion_radius: float):
	# clients get this event when the server tells them an asteroid impacts the surface
	if asteroid_id == id:
		queue_free()

func _on_asteroid_destroyed(asteroid_id, position: Vector2, size: float):
	# clients get this event when the server tells them an asteroid is destroyed
	if asteroid_id == id:
		queue_free()


func get_attributes() -> Array:
	# get the attributes of this asteroid as a dictionary
	# so we can send it over RPC
	return [
		id,
		base_speed,
		explosion_radius,
		base_distance,
		max_health,
		distance,
		speed,
		impact_vector
	]

func from_attributes(array: Array):
	var i = 0
	id = array[i]
	i += 1
	base_speed = array[i]
	i += 1
	explosion_radius = array[i]
	i += 1
	base_distance = array[i]
	i += 1
	max_health = array[i]
	i += 1
	distance = array[i]
	i += 1
	speed = array[i]
	i += 1
	impact_vector = array[i]
	i += 1

	_setup_initial_state()
