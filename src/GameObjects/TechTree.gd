extends Control

var texture_disabled = preload("res://assets/icons/techtree/disabled.png")
var texture_researching = preload("res://assets/icons/techtree/researching.png")
var texture_tier2 = preload("res://assets/icons/techtree/tier2.png")
var texture_tier3 = preload("res://assets/icons/techtree/tier3.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_tech_names()
	pass

func set_tech_names():
	get_node("TechTree/Row 1/TextureMine3/Mine3/LabelMine3").text = "Chromium\nMines"
	get_node("TechTree/Row 1/TextureMissile3/Missile3/LabelMissile3").text = "Ultimate\nMissiles"
	get_node("TechTree/Row 2/TextureMine2/Mine2/LabelMine2").text = "Titanium\nMines"
	get_node("TechTree/Row 2/TextureMissile2/Missile2/LabelMissile2").text = "Advanced\nMissiles"
	get_node("TechTree/Row 3/TextureMine1/Mine1/LabelMine1").text = "Iron\nMines"
	get_node("TechTree/Row 3/TextureMissile1/Missile1/LabelMine2").text = "Basic\nMissiles"
	get_node("TechTree/Middle Row/TexturePower3/Power3/LabelPower3").text = "Nuclear\nPower"
	get_node("TechTree/Middle Row/TexturePower2/Power2/LabelPower2").text = "Solar\nPower"
	get_node("TechTree/Middle Row/TexturePower1/Power1/LabelPower1").text = "Coal\nPower"
	get_node("TechTree/Middle Row/TextureShield1/Shield1/LabelShield1").text = "Basic\nShields"
	get_node("TechTree/Middle Row/TextureShield2/Shield2/LabelShield2").text = "Advanced\nShields"
	get_node("TechTree/Middle Row/TextureShield3/Shield3/LabelShield3").text = "Ultimate\nShields"
	get_node("TechTree/Row 4/TextureLaser1/Laser1/LabelLaser1").text = "Basic\nLasers"
	get_node("TechTree/Row 4/TextureScience1/Science1/LabelScience1").text = "Basic\nLabs"
	get_node("TechTree/Row 5/TextureLaser2/Laser2/LabelLaser2").text = "Advanced\nLasers"
	get_node("TechTree/Row 5/TextureScience2/Science2/LabelScience2").text = "Advanced\nLabs"
	get_node("TechTree/Row 6/TextureLaser3/Laser3/LabelLaser3").text = "Ultimate\nLasers"
	get_node("TechTree/Row 6/TextureScience3/Science3/LabelScience3").text = "Supreme\nLabs"

func set_tech_node_colors():
	var player = PlayersManager.whoami()

	update_node_texture(player, "TechTree/Row 2/TextureMine2", "mine2", true)
	update_node_texture(player, "TechTree/Row 1/TextureMine3", "mine3", false)

	#update_node_texture(player, "TechTree/Row 2/TextureMissile2", "missile2", true)
	#update_node_texture(player, "TechTree/Row 1/TextureMissile3", "missile3", false)

	update_node_texture(player, "TechTree/Middle Row/TexturePower2", "power2", true)
	update_node_texture(player, "TechTree/Middle Row/TexturePower3", "power3", false)

	update_node_texture(player, "TechTree/Middle Row/TextureShield2", "shield2", true)
	update_node_texture(player, "TechTree/Middle Row/TextureShield3", "shield3", false)

	update_node_texture(player, "TechTree/Row 5/TextureScience2", "science2", true)
	update_node_texture(player, "TechTree/Row 6/TextureScience3", "science3", false)

	update_node_texture(player, "TechTree/Row 5/TextureLaser2", "laser2", true)
	update_node_texture(player, "TechTree/Row 6/TextureLaser3", "laser3", false)
	
	set_missile_disabled()

func update_node_texture(p: PlayerData, node: String, tech_name: String, tier: bool):
	get_node(node).set_texture(texture_researching if p.selected_tech == tech_name else ((texture_tier2 if tier else texture_tier3) if p.selected_tech == "" && (is_tech_valid(tech_name) || has_tech(p, tech_name)) else texture_disabled))

func set_missile_disabled():
	$"TechTree/Row 3/TextureMissile1".set_texture(texture_disabled)
	$"TechTree/Row 2/TextureMissile2".set_texture(texture_disabled)
	$"TechTree/Row 1/TextureMissile3".set_texture(texture_disabled)

func has_tech(p: PlayerData, tech_name: String):
	var name = tech_name.substr(0, tech_name.length() - 1)
	var tier = int(tech_name.substr(tech_name.length() - 1, tech_name.length())) - 1
	return p.tech_level[name.to_lower()] >= tier

func is_tech_being_researched(tech):
	return PlayersManager.whoami().selected_tech == tech

#Returns the total tech cost of the currently researched tech
func get_cost_research() -> int:
	var p = PlayersManager.whoami()
	if(p.selected_tech == ""):
		return 0
	else:
		var t_name = p.selected_tech.substr(0, p.selected_tech.length() - 1).to_lower()
		return Constants.tech_costs[t_name][p.selected_tech]

func _on_Tech_pressed(tech_name):
	#Generic method for when a tech is pressed
	# Need to check:
	#	Is tech already unlocked
	#	Is tech the next tier (can't directly research Tier 3)
	#print(tech_name)

	var can_research = is_tech_valid(tech_name) && not is_player_researching() && not has_tech(PlayersManager.whoami(), tech_name)
	if(can_research):
		if($ResearchPopup.visible):
			$ResearchPopup.hide()
		$ResearchPopup.set_info(tech_name)
		$ResearchPopup.popup_centered()
	pass

func on_research_tech(tech: String):
	PlayersManager.whoami().selected_tech = tech.to_lower()
	PlayersManager.whoami().tech_research_progress = 0

	$ResearchPopup.hide()
	set_tech_node_colors()
	pass

func is_player_researching():
	return PlayersManager.whoami().selected_tech != ""

func is_tech_valid(tech):
	var tech_name = tech.substr(0, tech.length() - 1).to_lower()
	var tech_num = int(tech.substr(tech.length() - 1)) - 1

	if(tech_name == "missile"):
		return false

	if tech_num - PlayersManager.whoami().tech_level[tech_name] == 1:
		return true
	else:
		return false
	pass


func _on_show():
	if(self.visible):
		set_tech_node_colors()
		#$TechTree/ProgressBar/ResearchProgress.update_step(PlayersManager.whoami())
