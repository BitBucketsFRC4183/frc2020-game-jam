extends HBoxContainer

var player: Player

func _ready():
	assert(player)

	Signals.connect("player_owner_changed", self, "_on_player_owner_changed")
	# anytime the the player's resources change, update the UI
	player.connect("player_data_changed", self, "_on_player_data_changed")
	
	update_player_label()
	
	$ResourcesLabel.add_color_override("font_color", player.data.color)
	$ResourcesLabel.add_color_override("font_color_shadow", Color.darkgray)
	

func _on_player_data_changed(data):
	$Raw.text = "%s" % data.resources[Enums.resource_types.raw]

func _on_player_owner_changed(player_data: PlayerData):
	# if the owner changed, update our label
	if player_data.num == player.data.num:
		update_player_label()

func update_player_label():
	if player.data == PlayersManager.whoami():
		$ResourcesLabel.text = "%s's Resources (it me): " % player.data.name
	else:
		$ResourcesLabel.text = "%s's Resources (%s): " % [player.data.name, player.data.network_id]		
