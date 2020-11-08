extends CollisionPolygon2D

export var color: Color = Color.black
export var highlight_color: Color = Color.lightgray

onready var area2d = $Area2D

func _ready():
	$Polygon2D.polygon = polygon
	$Polygon2D.color = color

	call_deferred("_reparent_area2d")

func _reparent_area2d():
	# make this area2d our parent so we can create a polygon2d in the editor, but
	# use an Area2D with a polygon shape and collision box in game
	remove_child(area2d)
	get_parent().add_child(area2d)

	get_parent().remove_child(self)
	area2d.add_child(self)


# Pass along some area2d signals to the parent
func _on_Area2D_mouse_entered():
	$Polygon2D.color = highlight_color

func _on_Area2D_mouse_exited():
	$Polygon2D.color = color
