tool
extends TextureButton

export (Enums.game_buildings) var building = Enums.game_buildings.Mine

signal selected(building)

func _ready() -> void:
	match building:
		Enums.game_buildings.Mine:
			texture_normal = load("res://assets/icons/Mine.png")
		Enums.game_buildings.PowerPlant:
			texture_normal = load("res://assets/icons/Power Plant.png")
		Enums.game_buildings.ScienceLab:
			texture_normal = load("res://assets/icons/Lab.png")
		Enums.game_buildings.Radar:
			texture_normal = load("res://assets/icons/Radar.png")
		Enums.game_buildings.Missile:
			texture_normal = load("res://assets/icons/Missile.png")
		Enums.game_buildings.Laser:
			texture_normal = load("res://assets/icons/Laser.png")
		Enums.game_buildings.Shield:
			texture_normal = load("res://assets/icons/Shield.png")

func _on_GameBuildingButton_pressed() -> void:
	# pass the name of the building to be used to instance the scene (used to check hitboxes)
	emit_signal("selected", Enums.game_buildings.keys()[building])
	$ClickSound.play(.2)

