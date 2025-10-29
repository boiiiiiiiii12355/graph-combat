extends CharacterBody2D

@export var ruler_x : Line2D
@export var ruler_y : Line2D
@export var ruler_color = Color(0.282, 0.282, 0.282)
@export var ruler_width = 2
func _ready() -> void:
	ruler_x.add_point(Vector2(-1000, 0))
	ruler_y.add_point(Vector2(0, -1000))
	ruler_x.default_color = ruler_color
	ruler_y.default_color = ruler_color
	ruler_x.width = ruler_width
	ruler_y.width = ruler_width
