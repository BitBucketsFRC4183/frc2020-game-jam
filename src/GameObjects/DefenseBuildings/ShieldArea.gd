extends Area2D
class_name ShieldArea

export var active = false

var radius = 256.0
var cooldown = 10
var regen = 10
var max_health = 100
var health = max_health

onready var shape = CircleShape2D.new()
onready var collision = CollisionShape2D.new()
onready var sprite = $Sprite
onready var timer = $Timer

func _ready():
	Signals.connect("day_passed", self, "_on_day_passed")
	Signals.connect("shield_update", self, "_on_shield_update")
	Signals.connect("shield_damaged", self, "_on_shield_damaged")
	shape.set_radius(radius)
	collision.set_shape(shape)
	add_child(collision)
	sprite.set_scale(Vector2(radius * 2 / 512, radius * 2 / 512))

func _on_shield_update(building_id: String, active: bool):
	if get_parent().building_id == building_id:
		# If the server notified us this shield went down, start up the logic
		if self.active and not active:
			# are currently active, disable it
			disable()
		elif not self.active and active:
			# are currently active, damage it to make it inactive
			timer.stop()
			enable()


func _on_shield_damaged(building_id, damage):
	if get_parent().building_id == building_id:
		damage(damage)

			
func _on_Timer_timeout():
	enable()

func enable():
	health = max_health / 4
	sprite.visible = true
	active = true
	$RechargeAudio.play()

func _on_day_passed(day):
	if active:
		health += regen
		if health > max_health:
			health = max_health

func damage(damage):
	health -= damage
	if health <= 0:
		disable()
	$AsteroidStrikeAudio.play()
	
	# we survived! give us points
	PlayersManager.get_player(get_owner().player_num).add_score("asteroid_deflected")
	if get_tree().is_network_server():
		RPC.send_shield_damaged(get_parent().building_id, damage)


func disable():
	health = 0
	sprite.visible = false
	active = false
	timer.start(cooldown)

func set_radius(new_radius):
	radius = new_radius
	shape.set_radius(radius)
	sprite.set_scale(Vector2(radius * 2 / 512, radius * 2 / 512))
