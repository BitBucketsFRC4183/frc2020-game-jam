extends HBoxContainer

var player: Player

func _ready():
	assert(player)
	# anytime the the player's resources change, update the UI
	player.connect("player_data_changed", self, "_on_player_data_changed")
	
	if player.data == PlayersManager.whoami():
		$ResourcesLabel.text = "%s's Resources (it me): " % player.data.name
	else:
		$ResourcesLabel.text = "%s's Resources: " % player.data.name		
	
	$ResourcesLabel.add_color_override("font_color", player.data.color)
	$ResourcesLabel.add_color_override("font_color_shadow", Color.darkgray)
	

func _on_player_data_changed(data):
	$Raw.text = "%s" % data.resources[Enums.resource_types.raw]

