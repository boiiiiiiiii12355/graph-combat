extends Camera2D

@export var zoom_amount = 0.5
var req_zoom = zoom
var curr_zoom = zoom
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom in"):
		curr_zoom -= Vector2(1, 1) * zoom_amount

	elif Input.is_action_just_pressed("zoom out"):
		curr_zoom += Vector2(1, 1) * zoom_amount



@export var min_zoom = 100
@export var max_zoom = 0.5
func _physics_process(delta: float) -> void:
	req_zoom = curr_zoom
	if req_zoom > Vector2(min_zoom, min_zoom):
		req_zoom = Vector2(min_zoom, min_zoom)

	elif req_zoom < Vector2(max_zoom, max_zoom):
		req_zoom = Vector2(max_zoom, max_zoom)

	zoom = lerp(zoom, req_zoom, 0.1)

	camera_movement()
	camera_shake(false)

@export var p1 : RigidBody2D
@export var p2 : RigidBody2D
func camera_movement():
	global_position = (p2.global_position + p1.global_position) / 2


var max_intensity = 100
var shake_offset = Vector2.ZERO
var intensity : Vector2
func camera_shake(set : bool):
	if set == false:
		intensity = lerp(intensity, Vector2(0, 0), 0.1)
		shake_offset = Vector2(randf_range(-intensity.x, intensity.x), randf_range(-intensity.y, intensity.y))
		offset = shake_offset
	else:
		intensity = max_intensity * Vector2(1, 1)
