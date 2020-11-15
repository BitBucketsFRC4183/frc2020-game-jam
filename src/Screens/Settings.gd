extends MarginContainer

onready var play_music_check_button = $VBoxContainer/CenterContainer/Panel/HBoxContainer/MenuButtons/MusicContainer/MusicCheckButton

func _ready():
	play_music_check_button.pressed = Settings.play_music


func _on_MusicCheckButton_toggled(button_pressed):
	Settings.play_music = button_pressed


func _on_Back_pressed():
	get_tree().change_scene("res://src/Main.tscn")
