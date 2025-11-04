extends Control

@export var player : RigidBody2D
@export var x_label : RichTextLabel
@export var y_label : RichTextLabel
@onready var ruler_x = player.ruler_x
@onready var ruler_y = player.ruler_y

func _process(delta: float) -> void:
	update_labels()
	
func update_labels():
	var x_label_pos = player.global_position.x
	var y_label_pos = player.global_position.y
	
	var x_text_offset = Vector2(0, 0)
	var y_text_offset = Vector2(0, 0)
	
	x_label.text = str(round(x_label_pos))
	y_label.text = str(round(-y_label_pos))
	x_label.global_position = x_text_offset + ruler_x.get_point_position(1)
	y_label.global_position = y_text_offset + ruler_y.get_point_position(1)
