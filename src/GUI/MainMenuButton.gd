extends Button

func _ready():
	# close our connection, we're done
	Network.close_connection()


func _on_Button_pressed() -> void:
	PlayersManager.reset_values()
	get_tree().change_scene("res://src/Main.tscn")
