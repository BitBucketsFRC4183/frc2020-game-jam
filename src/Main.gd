extends MarginContainer

func _ready():
	pass

# on exit, quit (obviously)
func _on_Exit_pressed():
	get_tree().quit()


func _on_HostGameButton_pressed():
	Network.host_game(false)
	get_tree().change_scene("res://src/Screens/Lobby.tscn")


func _on_JoinGameButton_pressed():
	hide()
	$JoinWindow.popup_centered()


func _on_NewGameButton_pressed():
	Network.host_game(true)
	Server.begin_game(true)
	RPC.send_ready_to_start()
	get_tree().change_scene("res://src/World.tscn")


func _on_JoinWindow_popup_hide():
	show()


func _on_CancelButton_pressed():
	Network.close_connection()
	$JoinWindow/VBoxContainer/MarginContainer/VBoxContainer/CancelButton.disabled = true


func _on_JoinButton_pressed():
	$JoinWindow/VBoxContainer/MarginContainer/VBoxContainer/CancelButton.disabled = false
	var host = $JoinWindow/VBoxContainer/HBoxContainer/HostEdit.text
	var port = $JoinWindow/VBoxContainer/HBoxContainer/PortEdit.text as int
	Network.join_game(host, port)
	get_tree().change_scene("res://src/Screens/Lobby.tscn")


func _on_SettingsButton_pressed():
	get_tree().change_scene("res://src/Screens/Settings.tscn")



