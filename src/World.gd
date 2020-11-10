extends Node2D

var Player = preload("res://src/GameObjects/Player.tscn")

var days = 0

func _ready():
	# The server sends us a day update and our client emits a day_passed signal
	Signals.connect("day_passed", self, "_on_day_passed")
	Signals.connect("player_updated", self, "_on_player_updated")
	
	for player in Network.playersManager.players:
		var p = Player.instance()	
		p.data = player
		add_child(p)


func _on_day_passed(day: int) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Day.text = "%d" % day

func _on_player_updated(id: int, player):
	$MarginContainer/VBoxContainer/HBoxContainer2/Raw.text = "%d" % player.resources[Enums.resource_types.raw]
