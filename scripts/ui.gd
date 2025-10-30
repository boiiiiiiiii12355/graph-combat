extends Control

@export var x_label : RichTextLabel
@export var y_label : RichTextLabel
@export var view : Viewport
func _physics_process(delta: float) -> void:
	player.paused = paused
	update_labels()
	
@export var player : CharacterBody2D
func update_labels():
	var x_label_pos = player.global_position.x
	var y_label_pos = player.global_position.y
	
	var x_text_offset = Vector2(-200, 0)
	var y_text_offset = Vector2(0, -200)
	
	x_label.text = str(round(x_label_pos))
	y_label.text = str(round(y_label_pos))
	x_label.global_position = x_text_offset + player.get_global_transform_with_canvas().origin
	y_label.global_position = y_text_offset + player.get_global_transform_with_canvas().origin

var paused = false
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause") and paused == false:
		paused = true
		gamemaster.time_speed_set(0)
		
	elif Input.is_action_just_pressed("pause") and paused == true:
		paused = false
		gamemaster.time_speed_set(1)


@export var dir_input : TextEdit
var expression = Expression.new()
var regex_x = RegEx.new()
func _on_text_edit_text_changed() -> void:
	var input_text = dir_input.text
	print(input_text)
	var error = expression.parse(input_text, ["x", "y"])
	if error == OK:
		var end = expression.execute([player.global_position.x, player.global_position.y])
		print(end)
