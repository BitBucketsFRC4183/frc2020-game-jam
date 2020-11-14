extends GameBuilding

export var damage = 20
export var cooldown = 0.5
var target = null

func _ready() -> void:
	is_defense_building = true
	is_resource_building = false
	Signals.connect("asteroid_destroyed", self, "_on_asteroid_destroyed")
	
	$Timer.start(cooldown)

func _process(delta):
	if target != null:
		$Beam.points[1] = target.global_position - $Beam.global_position
		if not $AudioStreamPlayer.playing:
			$AudioStreamPlayer.play(.5)
	else:
		$Beam.points[1] = $Beam.points[0]
		$AudioStreamPlayer.stop()

func reevaluate_targeting():
	if active:
		var areas = $LaserArea.get_overlapping_areas()
		var new_target
		for area in areas:
			if area is FallingAsteroid:
				new_target = area
				break
		target = new_target
	
func activate():
	.activate()
	$LaserArea/Sprite.visible = false

func _on_LaserArea_area_entered(area):
	if target == null:
		reevaluate_targeting()


func _on_LaserArea_area_exited(area):
	if target == area:
		reevaluate_targeting()

func _on_asteroid_destroyed(position, size):
	PlayersManager.whoami().add_score("asteroid_destroyed")
	if target == null or target.get_parent().destroyed:
		reevaluate_targeting()

func _on_Timer_timeout():
	if target != null:
		target.damage(damage)
	$Timer.start(cooldown)


func _on_Laser_mouse_entered():
	if active:
		$LaserArea/Sprite.visible = true

func _on_Laser_mouse_exited():
	if active:
		$LaserArea/Sprite.visible = false
