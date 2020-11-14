extends Area2D

export var active = false

var radius = 256.0

onready var shape = CircleShape2D.new()
onready var collision = CollisionShape2D.new()
onready var sprite = $Sprite

func _ready():
	shape.set_radius(radius)
	collision.set_shape(shape)
	add_child(collision)
	sprite.set_scale(Vector2(radius * 2 / 512, radius * 2 / 512))
