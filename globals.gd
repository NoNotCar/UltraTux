extends Node

var current_manifest_id: String
var manifest_root: String
var current_level = ""
var global_water_level: float
var editing = true
var lives = 10
var classic_level = 1
var big_coins = 0
enum GAME_MODE {SINGLE_STAGE, TESTING, CLASSIC}
var game_mode: GAME_MODE = GAME_MODE.SINGLE_STAGE
var levelGex = RegEx.create_from_string("([^\\/]+)\\.lvl$")
var maniGex = RegEx.create_from_string("(.+)\\/[^\\/]+\\.json$")


signal coins_updated
var coins = 0:
	set(value):
		coins = value
		emit_signal("coins_updated", value)
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(0,-10)
	
func load_manifest(manifest_path: String):
	var manifest = Saving.load_manifest(manifest_path)
	current_manifest_id = manifest.id
	manifest_root = maniGex.search(manifest_path).get_string(1)
	return manifest

func start_game(mode: GAME_MODE):
	game_mode = mode
	editing = false
	coins = 0
	big_coins = 0
	classic_level = 1
	if mode == GAME_MODE.CLASSIC:
		current_level = "%s/1-1.lvl" % manifest_root
		lives = 10
		get_tree().change_scene_to_file("res://ui/classic_info_screen.tscn")
	else:
		lives = 5
		get_tree().change_scene_to_file("res://game.tscn")
	

func to_next_level(coins: Array[bool]):
	if current_manifest_id:
		var level_id = levelGex.search(current_level).get_string(1)
		Saving.save_level_completion(current_manifest_id, level_id, coins)
	match game_mode:
		GAME_MODE.CLASSIC:
			classic_level += 1
			var possible_level = "%s/%s-%s.lvl" % [manifest_root, 1, classic_level]
			if FileAccess.file_exists(possible_level):
				current_level = possible_level
				get_tree().change_scene_to_file("res://ui/classic_info_screen.tscn")
				return
		GAME_MODE.SINGLE_STAGE:
			if current_manifest_id:
				editing = true
				get_tree().change_scene_to_file("res://ui/level_select/level_select.tscn")
				return
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
		"antarctic_night":
			return load("res://themes/antarctic/antarctic_night.tscn")
		"cave":
			return load("res://themes/cave/cave.tscn")
		"underwater":
			return load("res://themes/underwater/underwater.tscn")
		"castle":
			return load("res://themes/castle/castle.tscn")
	return null
