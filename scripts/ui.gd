extends Control

@export var player1 : RigidBody2D
@export var player2 : RigidBody2D
@export var player : RigidBody2D
@export var view : Viewport
func _ready() -> void:
	_on_text_edit_text_changed()
	get_tree().paused = true
	paused = true
	

var paused = true
func _physics_process(delta: float) -> void:
	ui_ctrl()
	if typing == false:
		#if Input.is_action_just_pressed("pause") and paused == false:
			#paused = true
			#get_tree().paused = true
			#anim_player.play("pause")

		if Input.is_action_just_pressed("pause") and paused == true:
			gamemaster.next_turn()
			
			
	if player:
		player.graphing()
		player.paused = paused
		
		check_dir_time()
	else:
		print(current_turn)
	




var current_turn
var resume_pos = Vector2(500, 0)
func ui_ctrl():
	current_turn = gamemaster.current_turn
	var p2_parent = p2_input.get_parent()
	var p1_parent = p1_input.get_parent()
	
	if current_turn == "P1":
		dir_input = p1_input
		player = player1
		p1_parent.global_position = lerp(p1_parent.global_position, Vector2(0, 0), 0.1)
	else:
		p1_parent.global_position = lerp(p1_parent.global_position, resume_pos, 0.1)
		
	if current_turn == "P2":
		dir_input = p2_input
		player = player2
		p2_parent.global_position = lerp(p2_parent.global_position, Vector2(0, 0), 0.1)
	else:
		p2_parent.global_position = lerp(p2_parent.global_position, resume_pos, 0.1)

	if current_turn == "Combat":
		get_tree().paused = false
		paused = false
	else:
		get_tree().paused = true
		paused = true



#responsible for checking both time and direction of graph slide
@export var dir_toggle : CheckButton
func check_dir_time():
	if not paused:
		if dir_toggle.button_pressed:
			var dir = "right"
			player.movement(dir)
		else:
			var dir = "left"
			player.movement(dir)
			
			

func calc_y(x):
	var y
	if y_error == OK:
		y = y_expression.execute([x])
	if y and not y_expression.has_execute_failed():
		return y
	else:
		return 0

func calc_x(curr_x):
	var x
	if x_error == OK:
		x = x_expression.execute([curr_x])
	if x and not x_expression.has_execute_failed():
		return x
	else:
		return 0
	
	
@export var dir_input : TextEdit
@export var p1_input : TextEdit
@export var p2_input : TextEdit
var y_expression = Expression.new()
var y_check = RegEx.new()
var x_expression = Expression.new()
var x_check = RegEx.new()
var y_error
var x_error
func _on_text_edit_text_changed() -> void:
	y_check.compile("(?<= =).*")
	x_check.compile("(?<=f\\().*?(?=\\))")
	var input_text
	var input_y
	var input_x
		
	if dir_input:
		input_text = dir_input.text
		input_y = y_check.search(input_text)
		input_x = x_check.search(input_text)
	
	if input_x and input_y:
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


func _on_opposite_direction_toggled(toggled_on: bool) -> void:
	if toggled_on:
		player.path_follow.progress = 0
	else:
		player.path_follow.progress = player.graph_end
