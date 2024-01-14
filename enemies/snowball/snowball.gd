extends CharacterBody2D


const SPEED = 32.0
const JUMP_VELOCITY = -400.0

static var hurts = true
var direction = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
static var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var active = false

func start():
	active = true


func _physics_process(delta):
	if !active: return
	if is_on_floor():
		if !$FloorCast.is_colliding():
			direction*=-1
			$AnimatedSprite2D.flip_h=direction == -1
			$FloorCast.position = Vector2.RIGHT*12*direction
		
		if direction:
			velocity.x = move_toward(velocity.x, SPEED * direction, delta * 100)
	else:
		velocity.y += gravity * delta
	move_and_slide()
	
func squish(tux: Tux):
	queue_free()
