extends HBoxContainer

var data: PlayerData

func _ready():

	Signals.connect("player_owner_changed", self, "_on_player_owner_changed")
	Signals.connect("player_data_updated", self, "_on_player_data_updated")
	
	update_player_label()

func _on_player_data_updated(data):
	if data.num == self.data.num:
		$Raw.text = "%s" % data.resources[Enums.resource_types.raw]

func _on_player_owner_changed(player_data: PlayerData):
	# if the owner changed, update our label
	if player_data.num == data.num:
		update_player_label()

func update_player_label():
	if data == PlayersManager.whoami():
		$ResourcesLabel.text = "%s's Resources (it me): " % data.name
	else:
		$ResourcesLabel.text = "%s's Resources (%s): " % [data.name, data.network_id]		
	$ResourcesLabel.add_color_override("font_color", data.color)
