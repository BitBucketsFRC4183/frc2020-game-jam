extends Node2D

func _ready():
	$AsteroidManager.territories = $Map.get_territories()

func _input(event):
	if(event.is_action_pressed("ui_tech_tree")):
		get_tree().change_scene("res://src/GameObjects/TechTree.tscn")
