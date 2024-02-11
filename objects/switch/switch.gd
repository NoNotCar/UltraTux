extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func pound(tux: Tux):
	bash(tux)

func bash(_t: Tux):
	var lvl = get_tree().get_first_node_in_group("Level")
	if lvl:
		lvl.switch_switch()


func _on_switch_state_state_changed(to):
	$Sprite2D.frame = int(to)
