extends Node


var current_level = ""
var global_water_level: float
var editing = true
var lives = 10
var best_time = INF


signal coins_updated
var coins = 0:
	set(value):
		coins = value
		emit_signal("coins_updated", value)
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(0,-10)




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
	return null
