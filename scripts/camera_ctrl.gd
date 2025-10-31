extends Camera2D

@export var zoom_amount = 0.5
var req_zoom = zoom
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom in"):
		req_zoom -= Vector2(1, 1) * zoom_amount
		
	elif Input.is_action_just_pressed("zoom out"):
		req_zoom += Vector2(1, 1) * zoom_amount
		
	


func _physics_process(delta: float) -> void:
	if req_zoom > Vector2(20, 20):
		req_zoom = Vector2(19, 19)
	elif req_zoom < Vector2(0.1, 0.1):
		req_zoom = Vector2(0.2, 0.2)
	
	zoom = lerp(zoom, req_zoom, 0.1)
