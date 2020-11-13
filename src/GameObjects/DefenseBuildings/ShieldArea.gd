extends Area2D
class_name ShieldArea

var radius = 256.0
var cooldown = 10
var regen = 10
var max_health = 100
var health = max_health
var active = true

onready var shape = CircleShape2D.new()
onready var collision = CollisionShape2D.new()
onready var sprite = $Sprite
onready var timer = $Timer

func _ready():
	Signals.connect("day_passed", self, "_on_day_passed")
	shape.set_radius(radius)
	collision.set_shape(shape)
	add_child(collision)
	sprite.set_scale(Vector2(radius * 2 / 512, radius * 2 / 512))

func _on_Timer_timeout():
	health = max_health / 4
	sprite.visible = true
	active = true
	
func _on_day_passed(day):
	if active:
		health += regen
		if health > max_health:
			health = max_health

func damage(damage):
	health -= damage
	if health <= 0:
		disable()
func disable():
	health = 0
	sprite.visible = false
	active = false
	timer.start(cooldown)
