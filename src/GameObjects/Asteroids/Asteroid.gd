extends Node2D

export var base_speed = 100
export var explosion_radius = 64
export var base_distance = 1000

onready var distance = base_distance * rand_range(0.75,3)
onready var speed = base_speed * rand_range(0.75,1.25)
onready var impact_point = $ImpactPoint
onready var asteroid = $Asteroid
var impact_vector = Vector2.ZERO

func _ready():
	asteroid.position += (Vector2(1,-1) * distance)
	impact_vector = (impact_point.position - asteroid.position).normalized()

func _process(delta):
	asteroid.position += (impact_vector * speed * delta)


func _on_ImpactPoint_area_entered(area):
	if area == asteroid:
		impact()
		
func impact():
	Signals.emit_signal("asteroid_impact", impact_point.global_position, explosion_radius)
	queue_free()
