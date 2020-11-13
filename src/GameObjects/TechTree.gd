extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	set_tech_names()
	set_tech_colors()
	set_valid_tech_colors()
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

func set_valid_tech_colors():
	var p = PlayersManager.whoami()
	var tier2 = preload("res://assets/icons/techtree/tier2.png")
	var tier3 = preload("res://assets/icons/techtree/tier3.png")

	if(p.tech_level["mine"] == 0):
		$"TechTree/Row 2/TextureMine2".texture = tier2
	if(p.tech_level["mine"] >= 1):
		$"TechTree/Row 1/TextureMine3".texture = tier3

	if(p.tech_level["power"] == 0):
		$"TechTree/Middle Row/TexturePower2".texture = tier2
	if(p.tech_level["power"] >= 1):
		$"TechTree/Middle Row/TexturePower3".texture = tier3

	if(p.tech_level["science"] == 0):
		$"TechTree/Row 5/TextureScience2".texture = tier2
	if(p.tech_level["science"] >= 1):
		$"TechTree/Row 6/TextureScience3".texture = tier3

	if(p.tech_level["laser"] == 0):
		$"TechTree/Row 5/TextureLaser2".texture = tier2
	if(p.tech_level["laser"] >= 1):
		$"TechTree/Row 6/TextureLaser3".texture = tier3

	if(p.tech_level["shield"] == 0):
		$"TechTree/Middle Row/TextureShield2".texture = tier2
	if(p.tech_level["shield"] >= 1):
		$"TechTree/Middle Row/TextureShield3".texture = tier3

	if(p.tech_level["missile"] == 0):
		$"TechTree/Row 2/TextureMissile2".texture = tier2
	if(p.tech_level["missile"] >= 1):
		$"TechTree/Row 1/TextureMissile3".texture = tier3
	pass

func is_tech_being_researched(tech):
	return PlayersManager.whoami().selected_tech == tech

func set_tech_colors():
	var p = PlayersManager.whoami()
	var disabled = preload("res://assets/icons/techtree/disabled.png")
	var res = preload("res://assets/icons/techtree/researching.png")
	var tier2 = preload("res://assets/icons/techtree/tier2.png")
	var tier3 = preload("res://assets/icons/techtree/tier3.png")

	$"TechTree/Row 1/TextureMine3".set_texture(tier3 if p.tech_level["mine"] == 2 else (res if is_tech_being_researched("mine3") else disabled))
	$"TechTree/Row 2/TextureMine2".set_texture(tier2 if p.tech_level["mine"] >= 1 else (res if is_tech_being_researched("mine2") else disabled))

	$"TechTree/Row 1/TextureMissile3".set_texture(tier3 if p.tech_level["missile"] == 2 else (res if is_tech_being_researched("missile3") else disabled))
	$"TechTree/Row 2/TextureMissile2".set_texture(tier2 if p.tech_level["missile"] >= 1 else (res if is_tech_being_researched("missile2") else disabled))

	$"TechTree/Middle Row/TexturePower3".set_texture(tier3 if p.tech_level["power"] == 2 else (res if is_tech_being_researched("power3") else disabled))
	$"TechTree/Middle Row/TexturePower2".set_texture(tier2 if p.tech_level["power"] >= 1 else (res if is_tech_being_researched("power2") else disabled))

	$"TechTree/Middle Row/TextureShield3".set_texture(tier3 if p.tech_level["shield"] == 2 else (res if is_tech_being_researched("shield3") else disabled))
	$"TechTree/Middle Row/TextureShield2".set_texture(tier2 if p.tech_level["shield"] >= 1 else (res if is_tech_being_researched("shield2") else disabled))

	$"TechTree/Row 6/TextureScience3".set_texture(tier3 if p.tech_level["science"] == 2 else (res if is_tech_being_researched("science3") else disabled))
	$"TechTree/Row 5/TextureScience2".set_texture(tier2 if p.tech_level["science"] >= 1 else (res if is_tech_being_researched("science2") else disabled))

	$"TechTree/Row 6/TextureLaser3".set_texture(tier3 if p.tech_level["laser"] == 2 else (res if is_tech_being_researched("laser3") else disabled))
	$"TechTree/Row 5/TextureLaser2".set_texture(tier2 if p.tech_level["laser"] >= 1 else (res if is_tech_being_researched("laser2") else disabled))

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
	print(tech_name)

	var can_research = is_tech_valid(tech_name) && not is_player_researching()
	var popup: String

	if(can_research):
		$ResearchPopup.set_info(tech_name)
		$ResearchPopup.popup_centered()
		$ResearchPopup.add_button("Research!", true, tech_name)
	pass

func on_research_tech(tech: String):
	PlayersManager.whoami().selected_tech = tech.to_lower()
	PlayersManager.whoami().tech_research_progress = 0

	$ResearchPopup.hide()
	set_tech_colors()
	pass

func is_player_researching():
	return PlayersManager.whoami().selected_tech != ""

func is_tech_valid(tech):
	var tech_name = tech.substr(0, tech.length() - 1).to_lower()
	var tech_num = int(tech.substr(tech.length() - 1)) - 1

	if tech_num - PlayersManager.whoami().tech_level[tech_name] == 1:
		return true
	else:
		return false
	pass


func _on_show():
	if(self.visible):
		print(PlayersManager.whoami().tech_level)
		set_valid_tech_colors()
		set_tech_colors()
