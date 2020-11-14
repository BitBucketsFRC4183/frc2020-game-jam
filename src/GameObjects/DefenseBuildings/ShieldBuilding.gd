extends GameBuilding

func _ready() -> void:
	is_defense_building = true
	is_resource_building = false

func activate():
	.activate()
	$ShieldArea.active = true
	$ShieldArea/Sprite.set_modulate(Color(1,1,1,0.25))


func _on_Shield_mouse_entered():
	if active:
		$ShieldArea/Sprite.set_modulate(Color(1,1,1,1))


func _on_Shield_mouse_exited():
	if active:
		$ShieldArea/Sprite.set_modulate(Color(1,1,1,0.25))
