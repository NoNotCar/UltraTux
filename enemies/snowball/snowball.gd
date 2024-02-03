extends CharacterBody2D


const SPEED = 32.0

static var hurts = true
var direction = -1

# Get the gravity from the project settings to be synced with RigidBody nodes.
static var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var active = false
var flip_cooldown = 0.0

const Corpse = preload("res://enemies/snowball/snowball_corpse.tscn")

func start():
	active = true

func flip_direction():
	if flip_cooldown:
		return
	direction*=-1
	$AnimatedSprite2D.flip_h=direction == -1
	$FloorCast.position = Vector2.RIGHT*12*direction
	$WallCast.target_position = Vector2.RIGHT * 14 * direction
	flip_cooldown = 0.2

func _physics_process(delta):
	if !active: return
	flip_cooldown = max(0, flip_cooldown - delta)
	if $WallCast.is_colliding():
		flip_direction()
	if is_on_floor():
		if !$FloorCast.is_colliding():
			flip_direction()
		if direction:
			velocity.x = move_toward(velocity.x, SPEED * direction, delta * 100)
	else:
		velocity.y += gravity * delta
	move_and_slide()
	
func squish(tux: Tux):
	var corpse = Corpse.instantiate()
	corpse.flipped = direction == 1
	corpse.position = position + Vector2.DOWN * 8
	get_parent().add_child(corpse)
	queue_free()
