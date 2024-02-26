extends StaticBody2D




func impact():
	var lvl = get_tree().get_first_node_in_group("Level")
	if lvl:
		lvl.switch_switch()

func _on_switch_state_state_changed(to):
	$Sprite2D.frame = int(to)
