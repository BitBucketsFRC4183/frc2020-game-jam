extends GameBuilding

func _ready() -> void:
	is_defense_building = true
	is_resource_building = false
	
	Signals.connect("day_passed", self, "_on_day_passed")
	tech_check()

func tech_check():
	var building_owner := PlayersManager.get_player(player_num)
	var radius = 256.0
	var health = 100
	var regen = 10
	
	if building_owner.tech_level["shield"] == 1:
		radius = 288.0
		health = 200
		regen = 20
		
	if building_owner.tech_level["shield"] == 2:
		health = 400
		radius = 320.0
		regen = 40
	
	$ShieldArea.set_radius(radius)
	$ShieldArea.max_health = health
	$ShieldArea.regen = regen

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
		
func _on_day_passed(day):
	tech_check()
