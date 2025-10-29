extends CharacterBody2D

@export var ruler_x : Line2D
@export var ruler_y : Line2D
@export var ruler_x_color = Color(0.788, 0.0, 0.0, 1.0)
@export var ruler_y_color = Color(0.0, 0.672, 0.0, 1.0)
@export var ruler_width = 2

var paused = false

func _ready() -> void:
	ruler_x.add_point(Vector2(-1000, 0))
	ruler_y.add_point(Vector2(0, -1000))
	ruler_x.default_color = ruler_x_color
	ruler_y.default_color = ruler_y_color
	ruler_x.width = ruler_width
	ruler_y.width = ruler_width

func _process(delta: float) -> void:
	move_and_slide()
	
func _physics_process(delta: float) -> void:
	movement()
	
@export var gravity = 9.3
func movement():
	if paused == false:
		if not is_on_floor():
			velocity.y += gravity
		
