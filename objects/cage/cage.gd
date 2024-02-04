extends StaticBody2D

var broken = false

	
func bash(tux: Tux):
	destroy()

func pound(tux: Tux):
	destroy()

func destroy():
	if broken:
		return
	broken = true
	$Sprite.frame = 1
	get_tree().get_first_node_in_group("Game").complete_level()
