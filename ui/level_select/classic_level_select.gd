extends AcceptDialog

const lvlButton = preload("res://ui/level_select/classic_level_button.tscn")

func show_for_id(id: String):
	for c in $GridContainer.get_children():
		c.queue_free()
	var complete = Saving.get_level_completion(id)
	for lvl in complete.keys():
		var lb = lvlButton.instantiate()
		lb.level = lvl
		lb.coins = complete[lvl]
		$GridContainer.add_child(lb)
	popup_centered()
