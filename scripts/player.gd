extends RigidBody2D

@export var ruler_x : Line2D
@export var ruler_y : Line2D
@export var ruler_x_color = Color(0.0, 0.373, 0.599, 1.0)
@export var ruler_y_color = Color(0.0, 0.598, 0.951, 1.0)
@export var ruler_width = 2
var graph_end
var paused = true

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
	hit_sound.pitch_scale = lerp(hit_sound.pitch_scale, Engine.time_scale, 0.2)
	if paused == false:
		movement()


var move_on_graph = false
var accel = 600
func movement():
	if not path_follow.progress == graph_end:
		gravity_scale = 0
		rope_ride()


	else:
		gravity_scale = .3

var stored_momentum : Vector2
func rope_ride():
	linear_velocity = (path_follow.global_position - global_position) * 100
	stored_momentum = linear_velocity
	angular_velocity = (rotation - path_follow.rotation) * 50
	path_follow.progress += 10


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
@export var cam : Camera2D
@export var world_boundary = Vector2(500, 500)
var lerp_weight = 0.5
var center_point = 13
var offset = 1
var input_y = 0
var graph_mem : Array[Vector2]
#also handles detecting current and next pt
func graphing():

	var cam_border = cam.get_viewport_rect().size
#____________________________________________________camera bounds



	for pt in graph.get_point_count():

#_____________________________________________________graphing!!!
		var pt_x
		var pt_y
		if pt == center_point:
			pt_x = 0
			pt_y = ui.calc_y(pt_x)

		elif pt < center_point  or  pt > center_point:
			pt_x = offset *(pt - center_point)
			pt_y = ui.calc_y(pt_x)


		var req = Vector2(pt_x, -pt_y)
		req = req.clamp(-cam_border, cam_border)
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
	graph_end = path.curve.get_baked_length()

@export var hit_particle_effect : GPUParticles2D
func hit_particle(subject):
	hit_particle_effect.global_position = (global_position + subject.global_position) / 2
	hit_particle_effect.look_at(subject.global_position)
	hit_particle_effect.restart()


@export var hit_sound : AudioStreamPlayer2D
func _on_area_2d_area_entered(area : Area2D):
	if area.is_in_group("p2"):
		area.get_parent().angular_velocity = 50
		area.get_parent().linear_velocity = stored_momentum
		stored_momentum = Vector2.ZERO
		hit_particle(area)
		gamemaster.juice(cam)
		hit_sound.play()
