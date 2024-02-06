extends StaticBody2D

var breaking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



	
func bash(_tux: Tux):
	destroy()

func pound(_tux: Tux):
	destroy()

func destroy():
	if breaking:
		return
	breaking = true
	$CollisionShape2D.set_deferred("disabled", true)
	z_index = -1
	var deathTween = get_tree().create_tween()
	deathTween.tween_property($Sprite,"scale",Vector2.ZERO,0.25)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	deathTween.parallel().tween_property($Sprite,"rotation",randf_range(-6,6),0.25)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	deathTween.finished.connect(queue_free)
