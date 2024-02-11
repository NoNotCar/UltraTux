extends StaticBody2D

var target: Tux
var spin = 0.0
var launching = false
const FB = preload("res://enemies/fireball/fireball.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if spin:
		$Launching.rotation += spin * delta
	if not launching and target:
		launch(target)

func launch(t: Tux):
	launching = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property($Launching, "scale", Vector2.ONE, 0.2 ).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "spin", Fireball.ROTATION_SPEED, 1.0)
	await tween.finished
	var fb = FB.instantiate()
	fb.velocity = (t.position - position).normalized() * 128.0
	fb.position = position
	get_parent().add_child(fb)
	$Launching.scale = Vector2.ZERO
	spin = 0.0
	launching = false
	
	


func _on_vision_body_entered(body):
	if body is Tux:
		target = body


func _on_vision_body_exited(body):
	if body == target:
		target = null
