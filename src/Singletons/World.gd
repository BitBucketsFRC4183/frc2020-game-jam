extends Node2D

func _on_Timer_timeout() -> void:
	print("10 seconds gone ")
	Signals.emit_signal("day_passed")
