class_name player_1
extends RigidBody2D

@export var playerid : String
@export var ruler_x : Line2D
@export var ruler_y : Line2D
@export var ruler_x_color = Color(0.0, 0.373, 0.599, 1.0)
@export var ruler_y_color = Color(0.0, 0.598, 0.951, 1.0)
@export var ruler_width = 2
var graph_end
var paused = true

func _ready() -> void:
	ruler_x.default_color = ruler_x_color
	ruler_y.default_color = ruler_y_color
	ruler_x.width = ruler_width
	ruler_y.width = ruler_width
	graph_mem.resize(graph.get_point_count())
	anim_player = player_rig.get_child(0)
	R_arm = player_rig.get_child(2)
	L_arm = player_rig.get_child(3)
	body = player_rig.get_child(4)
	init_path()
	center_point = roundi((graph.get_point_count() + 1) / 2)


func init_path():
	path.curve.clear_points()
	for pt in graph.get_point_count():
		path.curve.add_point(graph.get_point_position(pt), Vector2(0, 0), Vector2(0, 0))


func _physics_process(delta: float) -> void:
	ruler()
	hit_sound.pitch_scale = lerp(hit_sound.pitch_scale, Engine.time_scale, 0.2)


var move_on_graph = false
var accel = 600
func movement(graph_zip_dir : String):
	if graph_zip_dir == "right":
		if not path_follow.progress >= graph_end:
			gravity_scale = 0
			R_arm.gravity_scale = 0
			L_arm.gravity_scale = 0
			body.freeze = false
			rope_ride(graph_zip_dir)
		else:
			let_go()
			
	elif graph_zip_dir == "left":
		if not path_follow.progress <= 0:
			gravity_scale = 0
			R_arm.gravity_scale = 0
			L_arm.gravity_scale = 0
			body.freeze = false
			rope_ride(graph_zip_dir)
		else:
			let_go()
			
#run this when reaching end of graph
func let_go():
	gravity_scale = .3
	R_arm.gravity_scale = .3
	L_arm.gravity_scale = .3
	body.global_position = lerp(body.global_position, global_position, 0.1)
	body.freeze = true
	anim_control("let_go")
	
	
var stored_momentum : Vector2
var graph_zip_speed : int = 10
func rope_ride(graph_zip_dir : String):
	var vel = (path_follow.global_position - global_position)
	linear_velocity = vel * 100 
	angular_velocity += -(rotation - path_follow.rotation) * 10
	R_arm.global_position = lerp(R_arm.global_position, path_follow.global_position, 0.7)
	L_arm.global_position = lerp(L_arm.global_position, path_follow.global_position, 0.7)
	stored_momentum = linear_velocity
	
	if graph_zip_dir == "left":
		path_follow.progress -= graph_zip_speed
	elif graph_zip_dir == "right":
		path_follow.progress += graph_zip_speed
	
	
var R_arm : RigidBody2D
var L_arm : RigidBody2D
var body : RigidBody2D
@export var player_rig : StaticBody2D
var anim_player : AnimationPlayer
var last_anim : String
func anim_control(anim : String):
	if last_anim != anim:
		if anim_player.is_playing() == false:
			anim_player.play(anim)
	
	if anim_player.current_animation:
		last_anim = anim_player.current_animation
		
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
			pt_x = ui.calc_x(0)
			pt_y = ui.calc_y(0)

		elif pt < center_point  or  pt > center_point:
			pt_x = ui.calc_x(offset *(pt - center_point))
			pt_y = ui.calc_y(offset *(pt - center_point))


		var req = Vector2(pt_x, -pt_y)
		req = req.clamp(-cam_border, cam_border)
		update_graph(pt, req)


#__________________________________________________pathing!!!
		if graph_mem[pt] != req:
			graph_mem[pt] = req
			update_path(pt, req)



#oracle predicts player movement when paused (not done yet)
@export var oracle_agent : RigidBody2D
func oracle(switch : bool):
	pass
	

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
