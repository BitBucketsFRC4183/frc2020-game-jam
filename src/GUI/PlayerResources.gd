extends VBoxContainer

var player_num: int = 1

onready var raw_label = $RawResourcesContainer/Label
onready var power_label = $PowerContainer/Label
onready var science_label = $ScienceContainer/Label

onready var raw_format = raw_label.text
onready var power_format = power_label.text
onready var science_format = science_label.text

func _ready():
	# on ready, setup our player number to whoever we are
	var player = PlayersManager.whoami()
	player_num = player.num
	Signals.connect("player_data_updated", self, "_on_player_data_updated")
	modulate = player.color
	
	#$RawResourcesContainer/TextureRect.modulate = player.color
	#$PowerContainer/TextureRect.modulate = player.color
	#$ScienceContainer/TextureRect.modulate = player.color

func _on_player_data_updated(data):
	if data.num == PlayersManager.whoami().num:
		raw_label.text = raw_format % data.resources[Enums.resource_types.raw]
		power_label.text = power_format % data.resources[Enums.resource_types.power]
		science_label.text = science_format % data.resources[Enums.resource_types.science]
