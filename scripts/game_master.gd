class_name GameMaster
extends Node2D

var time_value = 1
var accel = 0.1
var current_turn : String = "P1"
var turn_order : Array = ["P1", "P2"]
var base_combat_time = 1 #seconds
var combat_time = base_combat_time

func _physics_process(delta: float) -> void:
	Engine.time_scale = lerp(Engine.time_scale, time_value, accel)

func next_turn():
	combat_time = base_combat_time
	# available strings "P1" "P2" "Combat"
	if current_turn == "P1":
		current_turn = "Combat"
		await combat_tick(combat_time) == true
		current_turn = turn_order[1]
	elif current_turn == "P2":
		current_turn = "Combat"
		await combat_tick(combat_time) == true
		current_turn = turn_order[0]

func advantage():
	combat_time += 0.5
	
func combat_tick(time):
	var done = false
	for int in combat_time:
		await get_tree().create_timer(1).timeout
		combat_time -= 1

		if int == 0:
			done = true
		else:
			done = false
	return done

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	time_speed_set(1)


func time_speed_set(_0to1_ : float):
	print("set")
	time_value = _0to1_

func juice(camera : Camera2D):
	time_speed_set(0.01)
	Engine.time_scale = 0.01
	camera.max_zoom = 5
	camera.camera_shake(true)
	await get_tree().create_timer(0.03).timeout
	time_speed_set(1.0)
	camera.max_zoom = .5
	await get_tree().create_timer(0.1).timeout
