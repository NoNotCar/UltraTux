extends Node

const MAX_STARS = 15
const FILE_DIALOG_SIZE = Vector2(600,400)
const CLASSIC_MANIFEST = "res://levels/classic/manifest.json"
# Called when the node enters the scene tree for the first time.
func _ready():
	if not OS.has_feature("web"):
		$CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/MainButtons/Quit.show()
	var classic_progress = Saving.get_level_completion("classic")
	if classic_progress.has("1-5"):
		%Stars/Star1.show()
		var total_coins = 0
		for lvl in classic_progress.values():
			for coin in lvl:
				if coin:
					total_coins += 1
		if total_coins >= MAX_STARS * 0.5:
			%Stars/Star2.show()
		if total_coins >= MAX_STARS:
			%Stars/Star3.show()
	$Level.load_level("res://levels/title/1-title.lvl")
	var manifests = Saving.get_all_files("res://levels", "manifest.json")
	manifests.append_array(Saving.get_all_files("user://", "manifest.json"))
	for m in manifests:
		if m!=CLASSIC_MANIFEST:
			var loaded = Globals.load_manifest(m)
			var button = Button.new()
			button.text = loaded.name
			%BonusOptions.add_child(button)
			%BonusOptions.move_child(button, 0)
			button.pressed.connect(load_manifest.bind(m))

func load_manifest(path: String):
	var manifest = Globals.load_manifest(path)
	if manifest.mode == "classic":
		if Saving.get_level_completion(manifest.id).size():
			%MainButtons.hide()
			%BonusOptions.hide()
			%GameOptions.show()
		else:
			_on_from_start_pressed()
	elif manifest.mode == "bonus":
		_on_level_select_pressed()
			
		


func _on_editor_pressed():
	Globals.current_level = null
	get_tree().change_scene_to_file("res://editor.tscn")


func _on_classic_pressed():
	load_manifest(CLASSIC_MANIFEST)


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://ui/credits.tscn")


func _on_level_select_pressed():
	await $Level.fade_out()
	get_tree().change_scene_to_file("res://ui/level_select/level_select.tscn")


func _on_from_start_pressed():
	Globals.start_game(Globals.GAME_MODE.CLASSIC)
	
	
func _on_from_world_2_pressed() -> void:
	Globals.start_game(Globals.GAME_MODE.CLASSIC, 2)


func _on_bonus_levels_pressed():
	%MainButtons.hide()
	%BonusOptions.show()

func _on_load_level_pressed():
	$CanvasLayer/LoadLevelDialog.popup_centered(FILE_DIALOG_SIZE)

func _on_load_level_dialog_file_selected(path):
	Globals.clear_manifest()
	Globals.current_level = path
	Globals.start_game(Globals.GAME_MODE.SINGLE_STAGE)




func _on_bonus_back_pressed():
	%MainButtons.show()
	%BonusOptions.hide()


func _on_options_pressed():
	%MainButtons.hide()
	%ActualOptions.show()
	


func _on_actual_options_confirmed():
	%MainButtons.show()
	%ActualOptions.hide()



func _on_quit_pressed():
	get_tree().quit()
