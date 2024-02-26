extends Control

const lvlButton = preload("res://ui/level_select/bonus_level_button.tscn")

func _ready():
	var dir = DirAccess.open(Globals.manifest_root)
	var complete = Saving.get_level_completion(Globals.current_manifest_id)
	$Label.text = Globals.manifest_name
	for lvl in dir.get_files():
		if lvl.ends_with(".lvl"):
			var lb = lvlButton.instantiate()
			lvl = lvl.trim_suffix(".lvl")
			lb.level = lvl
			if complete.has(lvl):
				lb.coins = complete[lvl]
			%LevelList.add_child(lb)


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://title.tscn")

