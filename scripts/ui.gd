extends Control

@export var player : RigidBody2D
@export var view : Viewport
func _ready() -> void:
	_on_text_edit_text_changed()
	paused = true
	anim_player.play("pause")
	gamemaster.time_speed_set(0)


var paused = false
func _physics_process(delta: float) -> void:
	if typing == false:
		if Input.is_action_just_pressed("pause") and paused == false:
			paused = true
			anim_player.play("pause")
			gamemaster.time_speed_set(0)

		elif Input.is_action_just_pressed("pause") and paused == true:
			paused = false
			anim_player.play("resume")
			gamemaster.time_speed_set(1)
	player.paused = paused

@export var anim_player : AnimationPlayer

func calc_y(x):
	var y
	if error == OK:
		y = expression.execute([x])
	if y and not expression.has_execute_failed():
		return y
	else:
		return 0

@export var dir_input : TextEdit
var expression = Expression.new()
var error
func _on_text_edit_text_changed() -> void:
	var input_text = dir_input.text
	calc_y(0)
	player.path_follow.progress = 0
	error = expression.parse(input_text, ["x"])



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
