tool

extends CollisionPolygon2D

export var color: Color = Color.black setget set_color
export var highlight_color: Color = Color.lightgray

onready var area2d = $Area2D

func _ready():
	$Polygon2D.polygon = polygon
	$Polygon2D.color = color
	
	if not Engine.editor_hint:
		call_deferred("_reparent_area2d")

func _reparent_area2d():
	# make this area2d our parent so we can create a polygon2d in the editor, but
	# use an Area2D with a polygon shape and collision box in game
	remove_child(area2d)
	get_parent().add_child(area2d)

	get_parent().remove_child(self)
	area2d.add_child(self)

func set_color(value):
	color = value
	$Polygon2D.color = color

# Pass along some area2d signals to the parent
func _on_Area2D_mouse_entered():
	$Polygon2D.color = highlight_color

func _on_Area2D_mouse_exited():
	$Polygon2D.color = color
