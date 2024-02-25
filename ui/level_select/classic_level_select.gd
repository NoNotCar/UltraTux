extends Control

const lvlButton = preload("res://ui/level_select/classic_level_button.tscn")

func _ready():
	var complete = Saving.get_level_completion(Globals.current_manifest_id)
	for lvl in complete.keys():
		var lb = lvlButton.instantiate()
		lb.level = lvl
		lb.coins = complete[lvl]
		%LevelGrid.add_child(lb)


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://title.tscn")
