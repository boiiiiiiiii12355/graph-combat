extends CharacterBody2D

@export var ruler_x : Line2D
@export var ruler_y : Line2D
@export var ruler_x_color = Color(0.788, 0.0, 0.0, 1.0)
@export var ruler_y_color = Color(0.0, 0.672, 0.0, 1.0)
@export var ruler_width = 1

var paused = false

func _ready() -> void:
	ruler_x.default_color = ruler_x_color
	ruler_y.default_color = ruler_y_color
	ruler_x.width = ruler_width
	ruler_y.width = ruler_width
	center_point = roundi((graph.get_point_count() + 1) / 2)
	
func _process(delta: float) -> void:
	move_and_slide()
	
func _physics_process(delta: float) -> void:
	debug_movement()
	ruler()
	graphing()
	
@export var gravity = 9.3
func movement():
	pass
	

	
	
var speed = 100
func debug_movement():
	var dir = Input.get_vector("left", "right", "up", 'down')
	velocity = dir * speed
	
func ruler():
	ruler_x.set_point_position(1, Vector2(global_position.x, 0))
	ruler_x.set_point_position(0, global_position)
	ruler_y.set_point_position(1, Vector2(0, global_position.y))
	ruler_y.set_point_position(0, global_position)
	
	
@export var graph : Line2D
@export var ui : Control
@export var graph_accel = 1
var lerp_weight = 0.1 / graph_accel

var center_point = 13
var offset = 1
var input_y = 0
func graphing():
	var center = global_position
	for pt in graph.get_point_count():
		
		if pt == center_point:
			var pt_x = 0
			var pt_y = ui.calc_y(pt_x)
			var curr_pos = graph.get_point_position(center_point)
			var req = Vector2(pt_x, -pt_y)
			graph.set_point_position(center_point, lerp(curr_pos, req, lerp_weight))
			
			
		if pt < center_point:
			var pt_x = -(offset * abs(pt - center_point))
			var pt_y = ui.calc_y(pt_x)
			var curr_pos = graph.get_point_position(pt)
			var req = Vector2(pt_x, -pt_y)
			graph.set_point_position(pt, lerp(curr_pos, req, lerp_weight))
			
		
		elif pt > center_point:
			var pt_x = offset * (pt - (center_point))
			var pt_y = ui.calc_y(pt_x)
			var curr_pos = graph.get_point_position(pt)
			var req = Vector2(pt_x, -pt_y)
			graph.set_point_position(pt, lerp(curr_pos, req, lerp_weight))
				
				
				
