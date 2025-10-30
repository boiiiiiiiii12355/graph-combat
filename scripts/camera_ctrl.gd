extends Camera2D

@export var zoom_amount = 0.1
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoom in"):
		zoom += Vector2(1, 1) * -zoom_amount
	elif Input.is_action_just_pressed("zoom out"):
		zoom += Vector2(1, 1) * zoom_amount
		
	clamp(zoom, Vector2(0.000001, 0.000001), Vector2(20, 20))
