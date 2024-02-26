extends CharacterBody2D


const P = 1.0
const D = 1.0
const MAX_ACCEL = 60.0
var chasing: Tux
var t = randf_range(-PI, PI)
var td = randf_range(1.0,2.0)
var last_error = Vector2.ZERO
@onready var home = position
static var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var crashing = false
var exploded = false
const AIR_RESISTANCE = 0.7

static var hurts = true

const Explosion = preload("res://common/explosion.tscn")

var active = false
func start():
	active = true

func _physics_process(delta):
	if not active:
		return
	var is_underwater = Globals.get_water_depth(position) > 0
	if crashing:
		$Bubbles.emitting = false
		velocity += Vector2.DOWN * gravity * delta
		if is_on_floor():
			kill()
		elif position.y > 64:
			queue_free()
	else:
		var target_position:Vector2
		if chasing:
			target_position = chasing.position
			$AnimatedSprite2D.flip_h = target_position.x > position.x
		else:
			t += td * delta
			t  = fmod(t, TAU)
			target_position = Vector2(home.x,home.y +  8*sin(t))
		var error = target_position - position
		var delta_error = (error - last_error) / delta
		var correction = P * error + D * delta_error
		last_error = error
		if $GroundCast.is_colliding():
			correction += Vector2.UP * MAX_ACCEL
		if correction.length() > MAX_ACCEL:
			correction = correction.normalized() * MAX_ACCEL
		velocity += correction * delta
		$Bubbles.emitting = is_underwater
	if is_underwater:
		Lib.water_damp(self,delta)
	else:
		velocity *= pow(AIR_RESISTANCE, delta)
	move_and_slide()


func _on_vision_body_entered(body):
	if body is Tux and not chasing:
		chasing = body
		last_error = chasing.position - position
		$AnimatedSprite2D.play("angry")
		$Alarm.play()

func squish(_tux: Tux):
	crashing = true
	$AnimatedSprite2D.play("falling")
	$CPUParticles2D.emitting = true
	
func kill():
	if not exploded:
		exploded = true
		var exp = Explosion.instantiate()
		exp.position = position
		get_parent().add_child(exp)
		queue_free()
	


