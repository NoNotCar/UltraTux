extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_callback($DeathZone.queue_free).set_delay(0.5)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.1).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.rotation = randf_range(-PI, PI)
	



func _on_death_zone_body_entered(body):
	if body.has_method("kill"):
		body.call_deferred("kill")
	elif body.has_method("impact"):
		body.call_deferred("impact")
		


func _on_death_zone_area_entered(area):
	if area.has_method("kill"):
		area.call_deferred("kill")
