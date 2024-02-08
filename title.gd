extends Node

const star = "★"
# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.is_debug_build():
		$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/TestZone.visible = true
	if Globals.classic_complete:
		$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Classic.text += " ★"
		if Globals.big_coins >= 5:
			$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Classic.text += star
		if Globals.big_coins >= 9:
			$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Classic.text += star
	$Level.load_level("res://levels/title/1-title.lvl")





func _on_editor_pressed():
	get_tree().change_scene_to_file("res://editor.tscn")


func _on_classic_pressed():
	Globals.start_game(Globals.GAME_MODE.CLASSIC)


func _on_test_zone_pressed():
	Globals.current_level = "user://1-3.lvl"
	Globals.start_game(Globals.GAME_MODE.SINGLE_STAGE)
