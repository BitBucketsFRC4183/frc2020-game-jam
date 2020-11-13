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


func _ready():
	asteroid.position += (Vector2(1,-1) * distance)
	impact_vector = (impact_point.position - asteroid.position).normalized()

func _process(delta):
	asteroid.position += (impact_vector * speed * delta)


func _on_ImpactPoint_area_entered(area):
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
		Signals.emit_signal("asteroid_impact", impact_point.global_position, explosion_radius)
		queue_free()

func destroy():
	destroyed = true
	Signals.emit_signal("asteroid_destroyed", global_position, size)
	queue_free()
