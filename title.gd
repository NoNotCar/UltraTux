extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Level.load_level("user://1-title.lvl")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_editor_pressed():
	get_tree().change_scene_to_file("res://editor.tscn")


func _on_classic_pressed():
	Globals.current_level = "user://1-1.lvl"
	Globals.lives = 10
	Globals.editing = false
	get_tree().change_scene_to_file("res://ui/classic_info_screen.tscn")
