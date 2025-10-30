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
	debug_movement()
	graphing()
	
@export var gravity = 9.3
func movement():
	pass
	
var speed = 1000
func debug_movement():
	var dir = Input.get_vector("left", "right", "up", 'down')
	velocity = dir * speed
	
	
	
	
@export var line : Line2D
var center_point = 6
var offset = 50
func graphing():
	var center = global_position
	for pt in line.get_point_count():
		line.set_point_position(center_point, center)
		if not pt == center_point:
			if pt < center_point:
				line.set_point_position(pt, center - Vector2(offset * abs(pt - center_point), 50))
				
				
			elif pt > center_point:
				line.set_point_position(pt, center + Vector2(offset * (pt - 5), 50))
				
				
				
