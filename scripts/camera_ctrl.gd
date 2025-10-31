extends Camera2D

@export var zoom_amount = 1
var req_zoom = zoom
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom in"):
		req_zoom -= Vector2(1, 1) * zoom_amount
		
	elif Input.is_action_just_pressed("zoom out"):
		req_zoom += Vector2(1, 1) * zoom_amount
		
	

@export var min_zoom = 100
@export var max_zoom = 5
func _physics_process(delta: float) -> void:
	if req_zoom > Vector2(min_zoom, min_zoom):
		req_zoom = Vector2(min_zoom, min_zoom)
		
	elif req_zoom < Vector2(max_zoom, max_zoom):
		req_zoom = Vector2(max_zoom, max_zoom)
	
	zoom = lerp(zoom, req_zoom, 0.1)
