extends Node2D

var active = false
var exit_prog = 0.0
const ToSpawn = preload("res://enemies/snowball/bouncing_snowball.tscn")

func start():
	active = true
	$Arrow.queue_free()
	$Exiting.position = Vector2(0,16)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not active:
		return
	if not $EmptyArea.get_overlapping_bodies():
		exit_prog += delta
		if exit_prog > 1.0:
			var spawning = ToSpawn.instantiate()
			spawning.position = position
			if rotation_degrees == 90:
				spawning.direction = 1
			get_parent().add_child(spawning)
			spawning.start()
			exit_prog = -3.0
		$Exiting.position = Vector2(0,(1 - pow(max(0,exit_prog), 2))*16)
		
func save_data():
	return Lib.int_angle(rotation)
	
func load_data(data):
	if data:
		rotation = data * TAU / 4
