extends Node2D

const TuxScene = preload("res://tux/tux.tscn")
# Called when the node enters the scene tree for the first time.
var ten_coins: Array[bool] = [false, false, false]
var time = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time += delta
	
func _ready():
	$Level.load_level(Globals.current_level)
	call_deferred("spawn_tux")


	
func spawn_tux():
	var spawn = get_tree().get_first_node_in_group("Spawn")
	var tux = TuxScene.instantiate()
	tux.position = spawn.position
	add_child(tux)
	$TuxCam.target = tux

func _input(event):
	if Globals.game_mode == Globals.GAME_MODE.TESTING and event.is_action_pressed("exit_testing"):
		get_tree().change_scene_to_file("res://editor.tscn")
		
func collect_ten_coin(n: int):
	if n > 0 and n < 4:
		ten_coins[n-1] = true
		$UI/TenCoinDisplay.collect(n)
	

func complete_level():
	$Level/Music.stop()
	$Victory.play()
	await $Victory.finished
	await $Level.fade_out()
	Globals.to_next_level(ten_coins)
	
