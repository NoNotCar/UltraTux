extends CharacterBody2D

static var hurts = true
const JUMP_VELOCITY = 180.0
const X_DAMP = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var active = false

func start():
	active = true

func _physics_process(delta):
	if not active:
		return
	
	velocity.x *= pow(X_DAMP,delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	else:
		velocity += JUMP_VELOCITY * get_floor_normal()
		$AnimatedSprite2D.play("jump")


	move_and_slide()
