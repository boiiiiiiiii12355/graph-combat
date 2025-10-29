class_name GameMaster
extends Node2D

var time_value = 1

func _physics_process(delta: float) -> void:
	Engine.time_scale = lerp(Engine.time_scale, time_value, 0.2)
	
func _ready() -> void:
	time_speed_set(time_value)
	
	
func time_speed_set(_0to1_ : float): 
	time_value = _0to1_
