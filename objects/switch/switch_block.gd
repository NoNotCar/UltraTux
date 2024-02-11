extends StaticBody2D

func _on_switch_state_state_changed(to: bool):
	$Sprite2D.frame = int(to)
	$CollisionShape2D.disabled = not to
	
