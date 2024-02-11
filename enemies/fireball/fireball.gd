extends Area2D
class_name Fireball

const ROTATION_SPEED = TAU * 4

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.rotation += ROTATION_SPEED * delta
	position += velocity * delta


func _on_body_entered(body):
	if body.has_method("kill"):
		body.call_deferred("kill")


func _on_area_entered(area):
	if area.has_method("kill"):
		area.call_deferred("kill")


func _on_way_off_screen_notifier_screen_exited():
	queue_free()


func _on_timer_timeout():
	$CollisionShape2D.disabled = true
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ZERO,0.1).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()
