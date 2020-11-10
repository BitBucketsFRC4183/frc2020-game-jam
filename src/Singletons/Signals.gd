extends Node

func _ready() -> void:
	OS.window_maximized = true

signal day_passed
signal resource_generated
signal game_building_selected
signal game_building_cancelled
