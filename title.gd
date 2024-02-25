extends Node

const star = "*"
const MAX_STARS = 15
const FILE_DIALOG_SIZE = Vector2(600,400)
# Called when the node enters the scene tree for the first time.
func _ready():
	#if Globals.classic_complete:
		#$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Classic.text += " " + star
		#if Globals.big_coins >= MAX_STARS * 0.5:
			#$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Classic.text += star
		#if Globals.big_coins >= MAX_STARS:
			#$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Classic.text += star
	$Level.load_level("res://levels/title/1-title.lvl")

func load_manifest(path: String):
	var manifest = Globals.load_manifest(path)
	if manifest.mode == "classic":
		if Saving.get_level_completion(manifest.id).size():
			%MainButtons.hide()
			%GameOptions.show()
		else:
			_on_from_start_pressed()
			



func _on_editor_pressed():
	Globals.current_level = null
	get_tree().change_scene_to_file("res://editor.tscn")


func _on_classic_pressed():
	load_manifest("res://levels/classic/manifest.json")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://ui/credits.tscn")


func _on_level_select_pressed():
	await $Level.fade_out()
	get_tree().change_scene_to_file("res://ui/level_select/level_select.tscn")


func _on_from_start_pressed():
	Globals.start_game(Globals.GAME_MODE.CLASSIC)


func _on_bonus_levels_pressed():
	%MainButtons.hide()
	%BonusOptions.show()

func _on_load_level_pressed():
	$CanvasLayer/LoadLevelDialog.popup_centered(FILE_DIALOG_SIZE)

func _on_load_level_dialog_file_selected(path):
	Globals.current_level = path
	Globals.start_game(Globals.GAME_MODE.SINGLE_STAGE)




func _on_bonus_back_pressed():
	%MainButtons.show()
	%BonusOptions.hide()
