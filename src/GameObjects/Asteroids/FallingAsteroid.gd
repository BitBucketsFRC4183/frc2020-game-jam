extends Area2D

class_name FallingAsteroid

func damage(damage):
	get_parent().damage(damage)

func get_id():
	return get_parent().id
