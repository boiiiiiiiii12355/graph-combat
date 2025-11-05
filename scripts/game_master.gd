class_name GameMaster
extends Node2D

var time_value = 1
var accel = 0.1

func _physics_process(delta: float) -> void:
	Engine.time_scale = lerp(Engine.time_scale, time_value, accel)

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	time_speed_set(1)


func time_speed_set(_0to1_ : float):
	time_value = _0to1_

func juice(camera : Camera2D):
	time_speed_set(0.01)
	Engine.time_scale = 0.01
	camera.max_zoom = 5
	camera.camera_shake(true)
	await get_tree().create_timer(0.02).timeout
	time_speed_set(1.0)
	camera.max_zoom = .5
	await get_tree().create_timer(0.1).timeout
