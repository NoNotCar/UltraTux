extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.1).set_ease(Tween.EASE_IN).set_delay(0.5)
	tween.tween_callback(queue_free)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.rotation = randf_range(-PI, PI)
	



func _on_death_zone_body_entered(body):
	if body.has_method("kill"):
		body.call_deferred("kill")
		
