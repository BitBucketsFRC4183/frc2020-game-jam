extends Node2D

func _on_DaysTimer_timeout() -> void:
	Signals.emit_signal("day_passed")
