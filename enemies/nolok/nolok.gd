extends CharacterBody2D

var watching: Tux
const JUMP_SPEED = 180.0
static var hurts = true
static var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jcool = 0.0
var died = false
var active = false

func start():
	active = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not active:
		return
	if is_on_floor():
		velocity = Vector2.ZERO
		$AnimatedSprite2D.animation = "default"
		if watching and watching.position.y < position.y - 16 and jcool <= 0:
			var d = -15 if watching.position.x < position.x else 15
			velocity = Vector2(d + randf_range(-15,15), -JUMP_SPEED + randf_range(-20,20))
			$Jump.play()
		if jcool > 0:
			jcool -= delta
	else:
		velocity += Vector2.DOWN * gravity * delta
		$AnimatedSprite2D.animation = "jump"
		jcool = 0.25
		if position.y > 0 and not died:
			died = true
			$Death.play()
	move_and_slide()


func _on_vision_body_entered(body):
	if body is Tux:
		watching = body
		

func _on_vision_body_exited(body):
	if body == watching:
		watching = null

	


func _on_death_finished():
	queue_free()
