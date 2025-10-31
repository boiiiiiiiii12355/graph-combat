extends CharacterBody2D

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
	for pt in graph.get_point_count():
		path.curve.add_point(graph.get_point_position(pt), Vector2(0, 0), Vector2(0, 0))
		
func _process(delta: float) -> void:
	move_and_slide()
	
func _physics_process(delta: float) -> void:
	debug_movement()
	ruler()
	graphing()
	if move_on_graph:
		movement()
		
	
var move_on_graph = false
@export var gravity = 9.3
func movement():
	move_on_graph = true
	
	

	
	
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
@export var graph_accel = 5
@export var path : Path2D
@export var world_boundary = Vector2(1000, 1000)
var lerp_weight = 0.5
var center_point = 13
var offset = 5
var input_y = 0
var closest_point : Vector2
var graph_mem : Array[Vector2]
#also handles detecting current and next pt	
func graphing():
	
	var center = global_position
	
	for pt in graph.get_point_count():
		#closest point tracker
		var closest_to_player = path.curve.get_closest_point(global_position)
		if graph.get_point_position(pt) == closest_to_player:
			if closest_to_player != closest_point:
				print(closest_to_player)
			closest_point = closest_to_player
			
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
