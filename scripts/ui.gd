extends Control

@export var player : CharacterBody2D
@export var view : Viewport
func _ready() -> void:
	_on_text_edit_text_changed()
	
func _physics_process(delta: float) -> void:
	player.paused = paused
	



var paused = false
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and paused == false:
		paused = true
		gamemaster.time_speed_set(0)
		
	elif Input.is_action_just_pressed("pause") and paused == true:
		paused = false
		gamemaster.time_speed_set(1)

func calc_y(x):
	var y
	if not expression.has_execute_failed():
		if error == OK:
			y = expression.execute([x])
		
	if y:
		return y
	else:
		return 0
		
@export var dir_input : TextEdit
var expression = Expression.new()
var error
	
func _on_text_edit_text_changed() -> void:
	var input_text = dir_input.text
	print(input_text)
	calc_y(0)
	error = expression.parse(input_text, ["x"])

		


func _on_input_mouse_entered() -> void:
	dir_input.editable = true
	dir_input.focus_mode = Control.FOCUS_ALL


func _on_input_mouse_exited() -> void:
	dir_input.editable = false
	dir_input.focus_mode = Control.FOCUS_NONE
