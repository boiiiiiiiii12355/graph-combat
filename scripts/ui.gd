extends Control

@export var player : RigidBody2D
@export var view : Viewport
func _ready() -> void:
	_on_text_edit_text_changed()
	paused = true
	get_tree().paused = true
	anim_player.play("pause")


var paused = true
func _physics_process(delta: float) -> void:
	if typing == false:
		if Input.is_action_just_pressed("pause") and paused == false:
			paused = true
			get_tree().paused = true
			gamemaster.time_speed_set(0)
			anim_player.play("pause")

		elif Input.is_action_just_pressed("pause") and paused == true:
			paused = false
			get_tree().paused = false
			gamemaster.time_speed_set(1)
			anim_player.play("resume")
	player.paused = paused

@export var anim_player : AnimationPlayer

func calc_y(x):
	var y
	if y_error == OK:
		y = y_expression.execute([x])
	if y and not y_expression.has_execute_failed():
		return y
	else:
		return 0

func calc_x():
	pass
	
	
@export var dir_input : TextEdit
var y_expression = Expression.new()
var y_check = RegEx.new()
var x_expression = Expression.new()
var x_check = RegEx.new()
var y_error
var x_error
func _on_text_edit_text_changed() -> void:
	player.path_follow.progress = 0
	
	y_check.compile("(?= x).*")
	x_check.compile("(?<! =)")
	
	var input_text = dir_input.text
	var input_y = y_check.search(input_text)
	var input_x = x_check.search(input_text)
	print(input_y.get_string())
	print(input_x.get_string())
	
	
	y_error = y_expression.parse(input_y.get_string(), ["x"])
	x_error = x_expression.parse(input_x.get_string(), ["x"])


var typing = false
func _on_input_mouse_entered() -> void:
	typing = true
	dir_input.editable = true
	dir_input.focus_mode = Control.FOCUS_ALL


func _on_input_mouse_exited() -> void:
	typing = false
	dir_input.editable = false
	dir_input.focus_mode = Control.FOCUS_NONE


func _on_mag_button_down() -> void:
	player.movement()
