extends Container


# OH NO, we have been disconnected!
func _ready():
	Signals.connect("server_disconnected", self, "_on_server_disconnected")


func _on_server_disconnected():
	PlayersManager.reset_values()
	if get_parent():
		for child in get_parent().get_children():
			if child != self:
				# blur out our parent background
				get_parent().get_child(0).modulate.a = .5
	$ServerDisconnectedDialog.show()


func _on_ServerDisconnectedDialog_confirmed():
	get_tree().change_scene("res://src/Main.tscn")
