extends RigidBody2D

var flipped = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.flip_h = flipped
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO, 0.5).set_delay(1.0).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
