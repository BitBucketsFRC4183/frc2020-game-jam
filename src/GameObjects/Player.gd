extends Node2D

onready var data: PlayerData = PlayerData.new()

func _ready() -> void:
	Signals.connect("resource_generated", self, "_on_resource_generated")


func _on_resource_generated(res_list):
	data.resources[res_list[0]] += res_list[1]
	RPC.send_player_updated(data)
