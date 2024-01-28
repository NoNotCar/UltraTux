extends CharacterBody2D


const SPEED = 24.0

static var hurts = true
var direction = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
static var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var active = false

func start():
	active = true


func _physics_process(delta):
	if !active: return
	if $WallCast.is_colliding():
		direction*=-1
		$AnimatedSprite2D.flip_h=direction == 1
		$AnimatedSprite2D.position.x = direction * -2
		$WallCast.target_position = Vector2.RIGHT*16*direction
	
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, delta * 50)

	move_and_slide()
