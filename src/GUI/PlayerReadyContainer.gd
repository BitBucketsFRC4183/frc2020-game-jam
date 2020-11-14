tool
extends Control

var PlayerColors = preload("res://assets/PlayerColors.tres")

export(int, 1, 5) var player_num = 1 setget set_player_num
export var ready: bool = false setget set_ready

var it_me := false

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_name()
	if not Engine.editor_hint:
		set_ready(PlayersManager.get_player(player_num).ready)
	Signals.connect("player_data_updated", self, "_on_player_data_updated")

func set_player_num(value):
	player_num = value
	_update_name()

func _update_name():
	if not Engine.editor_hint and PlayersManager.whoami().num == player_num:
		it_me = true

	$Name.modulate = PlayerColors.colors[player_num]
	$ReadyCheck.modulate = PlayerColors.colors[player_num]
	if not Engine.editor_hint:
		$Name.text = "%s%s" % [PlayersManager.get_player(player_num).name, " (me)" if it_me else ""]
	else:
		$Name.text = Constants.random_names[player_num-1]


func set_ready(value: bool):
	ready = value
	$Ready.text = "Ready" if ready else "Not Ready"
	$Ready.modulate = PlayerColors.colors[player_num] if ready else Color.white
	$ReadyCheck.visible = ready
	
func _on_player_data_updated(player):
	if player.num == player_num:
		_update_name()
		set_ready(player.ready)

