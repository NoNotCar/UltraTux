extends CharacterBody2D


const SPEED = 38.0
const JUMP_VELOCITY = 175.0
const EYE = 20

static var hurts = true
var direction = -1
var momentum = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
static var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var active = false
var flip_cooldown = 0.0

const Corpse = preload("res://enemies/snowball/snowball_corpse.tscn")

func start():
	active = true
	$AnimatedSprite2D.flip_h = direction == -1

func flip_direction():
	if flip_cooldown:
		return
	direction*=-1
	velocity.x = SPEED * direction * randf_range(0.3, 0.5)
	$AnimatedSprite2D.flip_h = direction == -1
	$WallCast.target_position = Vector2.RIGHT * 14 * direction
	flip_cooldown = 0.2

func _physics_process(delta):
	if !active: return
	if position.y > 48:
		queue_free()
		
	flip_cooldown = max(0, flip_cooldown - delta)
	if is_on_wall():
		flip_direction()
		
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.animation = "up" if velocity.y < -EYE else "hoz" if velocity.y < EYE else "down"
	else:
		if not $AnimatedSprite2D.animation == "bounce":
			$AnimatedSprite2D.play("bounce")
			momentum = velocity.x / (SPEED * direction)
			velocity.x = 0
	
	if Globals.get_water_depth(position) > 0:
		Lib.water_damp(self, delta)
		
	move_and_slide()
	
func squish(_tux: Tux):
	kill()

func kill():
	var corpse = Corpse.instantiate()
	corpse.flipped = direction == 1
	corpse.position = position + Vector2.DOWN * 8
	get_parent().add_child(corpse)
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "bounce" and is_on_floor():
		velocity.x = SPEED * (randf_range(0.8, 1.0) + momentum * 0.1) * direction
		velocity += (JUMP_VELOCITY + randf_range(-20, 20)) * get_floor_normal()
		if sign(velocity.x) != direction:
			flip_direction()
