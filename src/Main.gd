extends MarginContainer

# on exit, quit (obviously)
func _on_Exit_pressed():
	get_tree().quit()


func _on_Host_Game_pressed():
	get_tree().change_scene("res://src/World.tscn")


func _on_Join_Game_pressed():
	get_tree().change_scene("res://src/World.tscn")

