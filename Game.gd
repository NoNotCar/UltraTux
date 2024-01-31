extends Node2D

const TuxScene = preload("res://tux/tux.tscn")
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_level_loaded():
	$Music.stream = $Level.music
	$Music.play()
	call_deferred("spawn_tux")
	
func spawn_tux():
	var spawn = get_tree().get_first_node_in_group("Spawn")
	var tux = TuxScene.instantiate()
	tux.position = spawn.position
	add_child(tux)
	$TuxCam.target = tux

func _input(event):
	if event.is_action_pressed("exit_testing"):
		get_tree().change_scene_to_file("res://editor.tscn")
	
