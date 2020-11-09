extends MarginContainer

# on exit, quit (obviously)
func _on_Exit_pressed():
	get_tree().quit()


func _on_Host_Game_pressed():
	print("Hosting game")
	Network.host_game("Player 1")
	Network.server.begin_game()

	get_tree().change_scene("res://src/World.tscn")

func _on_Join_Game_pressed():
	print("joining game")
	Network.join_game("127.0.0.1", "Player 2")

	var world_scene = ResourceLoader.load("res://src/World.tscn")
	var instance = world_scene.instance()
	get_tree().root.add_child(instance)

	hide()	
