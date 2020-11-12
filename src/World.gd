extends Node2D

func _ready():
	$AsteroidManager.territories = $Map.get_territories()
