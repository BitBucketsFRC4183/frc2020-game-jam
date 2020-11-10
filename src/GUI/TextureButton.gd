extends TextureButton

signal button_selected(obj)

func _ready() -> void:
	connect("pressed", self, "_on_self_pressed")

func _on_self_pressed():
	emit_signal("button_selected", self)
