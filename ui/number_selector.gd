extends Node2D

@export var max_value = 9
@export var min_value = 0

var left_active = false
var right_active = false
var number: int:
	set(value):
		$Number.frame = value
	get:
		return $Number.frame

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Globals.editing:
		queue_free()
	else:
		if number < min_value:
			number = min_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action_pressed("editor_place"):
		if left_active:
			get_viewport().set_input_as_handled()
			if number > min_value:
				number -= 1
		elif right_active:
			get_viewport().set_input_as_handled()
			if number < max_value:
				number += 1

func _on_left_area_mouse_entered():
	$Left.scale = Vector2.ONE * 1.1
	left_active = true


func _on_left_area_mouse_exited():
	$Left.scale = Vector2.ONE
	left_active = false


func _on_right_area_mouse_entered():
	$Right.scale = Vector2.ONE * 1.1
	right_active = true


func _on_right_area_mouse_exited():
	$Right.scale = Vector2.ONE
	right_active = false
