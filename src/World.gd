extends Node2D

var days = 0

func _ready():
	# The server sends us a day update and our client emits a day_passed signal
	Signals.connect("day_passed", self, "_on_day_passed")
	

func _on_day_passed(day: int) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Day.text = "%d" % day
