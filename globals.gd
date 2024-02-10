extends Node


var current_level = ""
var global_water_level: float
var editing = true
var lives = 10
var classic_level = 1
var big_coins = 0
var classic_complete = false
enum GAME_MODE {SINGLE_STAGE, CLASSIC}
var game_mode: GAME_MODE = GAME_MODE.SINGLE_STAGE


signal coins_updated
var coins = 0:
	set(value):
		coins = value
		emit_signal("coins_updated", value)
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(0,-10)

func start_game(mode: GAME_MODE):
	game_mode = mode
	editing = false
	coins = 0
	big_coins = 0
	classic_level = 1
	if mode == GAME_MODE.CLASSIC:
		current_level = "res://levels/classic/1-1.lvl"
		lives = 10
		get_tree().change_scene_to_file("res://ui/classic_info_screen.tscn")
	else:
		lives = 5
		get_tree().change_scene_to_file("res://game.tscn")
	

func to_next_level():
	match game_mode:
		GAME_MODE.CLASSIC:
			classic_level += 1
			var possible_level = "res://levels/classic/%s-%s.lvl" % [1, classic_level]
			if FileAccess.file_exists(possible_level):
				current_level = possible_level
				get_tree().change_scene_to_file("res://ui/classic_info_screen.tscn")
				return
			else:
				classic_complete = true
	editing = true
	get_tree().change_scene_to_file("res://title.tscn")



func get_water_depth(pos: Vector2):
	if not global_water_level:
		return 0
	return max(0, pos.y - global_water_level)
	
func load_theme(theme: String)->PackedScene:
	match theme:
		"antarctic":
			return load("res://themes/antarctic/antarctic.tscn")
		"cave":
			return load("res://themes/cave/cave.tscn")
		"underwater":
			return load("res://themes/underwater/underwater.tscn")
	return null
