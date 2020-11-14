tool
extends Control

var PlayerColors = preload("res://assets/PlayerColors.tres")

var source_player_num = 1
export var player_num := 2 setget set_player_num
export var player_name := "Bit Buckets" setget set_player_name
export var resource_give_amount := 1 # default to give one resource

func _ready():
	if not Engine.editor_hint:
		source_player_num = PlayersManager.whoami().num
		
		Signals.connect("player_data_updated", self, "_on_player_data_updated")

func set_player_num(value):
	if value >= 0 && value < PlayerColors.colors.size():
		modulate = PlayerColors.colors[value]
		player_num = value

func set_player_name(value):
	player_name = value
	$PlayerName.text = value

func _on_player_data_updated(player_data: PlayerData):
	if player_data.num == player_num:
		$Resources/Raw/Value.text = "%s" % player_data.resources[Enums.resource_types.raw]
		$Resources/Power/Value.text = "%s" % player_data.resources[Enums.resource_types.power]
		$Resources/Science/Value.text = "%s" % player_data.resources[Enums.resource_types.science]

func _on_GiveRawButton_pressed():
	Signals.emit_signal("player_give_resources", source_player_num, player_num, Enums.resource_types.raw, resource_give_amount)


func _on_GivePowerButton_pressed():
	Signals.emit_signal("player_give_resources", source_player_num, player_num, Enums.resource_types.power, resource_give_amount)


func _on_GiveScienceButton_pressed():
	Signals.emit_signal("player_give_resources", source_player_num, player_num, Enums.resource_types.science, resource_give_amount)
