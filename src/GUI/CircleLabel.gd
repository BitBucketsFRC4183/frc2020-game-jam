tool
extends Control

export var label := "Day" setget set_label
export var value := "0" setget set_value
export var color := Color.white setget set_color

func _ready():
	$Label.text = label
	$HBoxContainer/CenterContainer/Value.text = value
	modulate = color


func set_label(value):
	$Label.text = value
	label = value
	
func set_value(new_value):
	$HBoxContainer/CenterContainer/Value.text = new_value
	value = new_value

func set_color(value: Color):
	modulate = value
	color = value
