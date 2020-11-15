extends ProgressBar

func _ready():
	Signals.connect("tech_progress_changed", self, "update_step")

	var font = DynamicFont.new()
	font.set_size(16)
	add_font_override("font", font)

	set_position(Vector2(460, 15))
	set_size(Vector2(1000, 30))
	set_value(0)

func update_step(p: PlayerData):
	var progress = p.tech_research_progress
	var cost = Constants.tech_costs[p.selected_tech.substr(0, p.selected_tech.length() - 1)][p.selected_tech]
	set_value(float(progress) / float(cost))

	if get_value() >= max_value:
		set_value(0.0)
		$TechTree.set_tech_node_colors()
