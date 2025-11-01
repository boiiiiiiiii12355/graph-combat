extends RigidBody2D

@export var ruler_x : Line2D
@export var ruler_y : Line2D
@export var ruler_x_color = Color(0.788, 0.0, 0.0, 1.0)
@export var ruler_y_color = Color(0.0, 0.672, 0.0, 1.0)
@export var ruler_width = 0.3

var paused = false

func _ready() -> void:
	init_path()
	ruler_x.default_color = ruler_x_color
	ruler_y.default_color = ruler_y_color
	ruler_x.width = ruler_width
	ruler_y.width = ruler_width
	graph_mem.resize(graph.get_point_count())
	center_point = roundi((graph.get_point_count() + 1) / 2)
	
func init_path():
	path.curve.clear_points()
	for pt in graph.get_point_count():
		path.curve.add_point(graph.get_point_position(pt), Vector2(0, 0), Vector2(0, 0))
		
	
func _physics_process(delta: float) -> void:
	ruler()
	graphing()
	path_follow.progress += 1
	if move_on_graph and paused == false:
		
		rope_ride()
	else:
		linear_velocity = Vector2.ZERO
		
	

var move_on_graph = false
var accel = 100
@export var gravity = 9.3
func movement():
	var dist = sqrt((path_follow.global_position.x - global_position.x) ** 2 + (path_follow.global_position.y - global_position.y) ** 2)
	var dir = (path_follow.global_position - global_position).normalized()
	var req_vel = dir * accel
	
	linear_velocity = lerp(linear_velocity, linear_velocity + req_vel, 0.1)
	move_on_graph = true
	
@onready var rope_pt : RigidBody2D = path.get_child(0).get_child(2)
func rope_ride():
	gravity_scale = 0
	global_position = rope_pt.global_position
	linear_velocity = rope_pt.linear_velocity
	
	
func ruler():
	ruler_x.set_point_position(1, Vector2(global_position.x, 0))
	ruler_x.set_point_position(0, global_position)
	ruler_y.set_point_position(1, Vector2(0, global_position.y))
	ruler_y.set_point_position(0, global_position)
	
	
@export var graph : Line2D
@export var ui : Control
@export var graph_accel = 5
@export var path : Path2D
@onready var path_follow = path.get_child(0)
@export var world_boundary = Vector2(1000, 1000)
var lerp_weight = 0.5
var center_point = 13
var offset = 5
var input_y = 0
var graph_mem : Array[Vector2]
#also handles detecting current and next pt	
func graphing():
	
	for pt in graph.get_point_count():
#_____________________________________________________closest_point

		
#_____________________________________________________graphing!!!
		var pt_x
		var pt_y
		if pt == center_point:
			pt_x = 0
			pt_y = ui.calc_y(pt_x)
			
		elif pt < center_point  or  pt > center_point:
			pt_x = (pt - center_point)
			pt_y = ui.calc_y(pt_x)
				
				
		var req = Vector2(pt_x, -pt_y)
		update_graph(pt, req)
			
			
#__________________________________________________pathing!!!
		if graph_mem[pt] != req:
			graph_mem[pt] = req
			update_path(pt, req)



func update_graph(pt, req):
	var curr_pos = graph.get_point_position(pt)
	graph.set_point_position(pt, lerp(curr_pos, req, lerp_weight))

func update_path(pt, req):
	path.curve.set_point_position(pt, req)
