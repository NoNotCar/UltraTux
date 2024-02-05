extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.is_debug_build():
		$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/TestZone.visible = true
	$Level.load_level("res://levels/title/1-title.lvl")
	if Globals.best_time != INF:
		$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Classic.text = \
		"Classic - Best time %.2fs" % Globals.best_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_editor_pressed():
	get_tree().change_scene_to_file("res://editor.tscn")


func _on_classic_pressed():
	Globals.current_level = "res://levels/classic/1-1.lvl"
	Globals.lives = 10
	Globals.editing = false
	get_tree().change_scene_to_file("res://ui/classic_info_screen.tscn")


func _on_test_zone_pressed():
	Globals.current_level = "user://layer_test.lvl"
	Globals.lives = 5
	Globals.editing = false
	get_tree().change_scene_to_file("res://game.tscn")
