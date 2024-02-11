extends Node2D




func _on_death_zone_body_entered(body):
	if body.has_method("kill"):
		body.call_deferred("kill")

func _on_death_zone_area_entered(area):
	if area.has_method("kill"):
		area.call_deferred("kill")
