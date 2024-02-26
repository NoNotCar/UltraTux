extends CharacterBody2D


const P = 1.0
const D = 0.1
const MAX_ACCEL = 60.0
var chasing: Tux
var t = randf_range(-PI, PI)
var td = randf_range(1.0,2.0)
var last_error = Vector2.ZERO
@onready var home = position
var firing = false
var dying = false
const WATER_RESISTANCE = 0.4
static var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const Bubble = preload("res://enemies/fish/puffer_bubble.tscn")

static var hurts = true

var active = false
func start():
	active = true

func _physics_process(delta):
	if dying or not active:
		return
	var depth = Globals.get_water_depth(position)
	if not firing and depth > 0:
		var target_position:Vector2
		if chasing:
			target_position = chasing.position
			$AnimatedSprite2D.flip_h = target_position.x > position.x
			if (abs(target_position.y - position.y) < 8.0):
				firing = true
				$AnimatedSprite2D.play("inflate")
				$Timer.start()
		else:
			t += td * delta
			t  = fmod(t, TAU)
			target_position = Vector2(home.x,home.y +  8*sin(t))
		var error = (target_position - position)* Vector2(1,3)
		var delta_error = (error - last_error) / delta
		var correction = P * error + D * delta_error
		last_error = error
		if correction.length() > MAX_ACCEL:
			correction = correction.normalized() * MAX_ACCEL
		velocity += correction * delta
	if depth <= 0:
		velocity += Vector2.DOWN * gravity * delta
	velocity *= pow(WATER_RESISTANCE, delta)
	move_and_slide()


func _on_vision_body_entered(body):
	if body is Tux and not chasing:
		chasing = body
		last_error = chasing.position - position


func _on_vision_body_exited(body):
	if body == chasing:
		chasing = null


func _on_timer_timeout():
	var bubble = Bubble.instantiate()
	bubble.position = position
	bubble.velocity = (Vector2.RIGHT if $AnimatedSprite2D.flip_h else Vector2.LEFT) * 120
	bubble.emitter = self
	get_parent().add_child(bubble)
	


func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("default")
	firing = false
	
func kill():
	var deathTween = get_tree().create_tween()
	deathTween.tween_property($AnimatedSprite2D,"scale",Vector2.ZERO,0.25)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	deathTween.parallel().tween_property($AnimatedSprite2D,"rotation",randf_range(-6,6),0.25)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	deathTween.finished.connect(queue_free)
