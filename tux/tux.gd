extends CharacterBody2D
class_name Tux

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
static var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump=0
var flip=false: set = set_flipped
var falling=true
var missile=false: set = set_missile
var last_falling=true
var mat: Material
var dying = false
const death_barrier = 32
const MPOS = Vector2(7.5,4)
const SMOKE_SPEED = 96.0

func _physics_process(delta):
	if dying or not visible:
		$RunSmoke.emitting = false
		return
	var dx = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var running=Input.is_action_pressed("run")
	$Sprite.speed_scale=1.5 if running else 1.0
	velocity+=Vector2.RIGHT*dx*delta*200*(int(running)+1)*(0.75 if falling else 1.0)
	velocity+=Vector2.DOWN*gravity*delta
	var jump_pressed = Input.is_action_pressed("jump")
	if jump:
		if jump_pressed:
			velocity+=Vector2.UP*55
		jump-=1
	if missile and jump_pressed:
		velocity+=Vector2.UP*gravity*0.5*delta
		$Missile.animation="fire"
	elif missile:
		$Missile.animation="default"
	velocity*=Vector2(pow(0.1,delta),pow(0.5,delta))
	move_and_slide()
	$RunSmoke.emitting = running and is_on_floor() and abs(velocity.x)>SMOKE_SPEED
	for s in get_slide_collision_count():
		var coll = get_slide_collision(s)
		var normal = coll.get_normal()
		var collider = coll.get_collider()
		if normal.dot(Vector2.UP)>0.5 and collider.has_method("squish"):
			collider.squish(self)
			if not jump:
				velocity+=Vector2.UP*40
				jump=3
		elif normal.dot(Vector2.DOWN)>0.5 and collider.has_method("bash"):
			collider.bash()
			velocity+=Vector2.DOWN*20
			$Bash.play()
		elif "hurts" in collider:
			spike()
			return
	var f=not is_on_floor()
	falling = f and last_falling
	last_falling=f
	if dx:
		$Sprite.animation="walk"
		set_flipped(dx<0)
	else:
		$Sprite.animation="sit"
	if falling:
		$Sprite.animation="jump_up" if velocity.y<0 else "jump_down"
	if position.y>death_barrier:
		die()
func _input(event):
	if dying or not visible:
		return
	if event.is_action("jump"):
		if not falling:
			jump=4
			$Jump.play()
		#elif get_clouds() and velocity.y>0:
			#var c = Cloud.instance()
			#c.position=position+Vector2.DOWN*16
			#get_parent().add_child(c)
			#$Clouds.n-=1
	#elif player.is_b(event) and missile:
		#set_missile(false)
		#var m = Missile.instance()
		#m.position=global_position+(Vector2.LEFT if flip else Vector2.RIGHT)*16
		#m.linear_velocity=velocity
		#m.flipped=flip
		#get_parent().add_child(m)

func set_missile(new:bool):
	missile=new
	$Missile.visible=new

func set_flipped(new:bool):
	flip=new
	$Sprite.flip_h=new
	#$Missile.position=MPOS*(Vector2(-1,1) if not new else Vector2.ONE)+Vector2.LEFT*0.5
	#$Missile.flip_h=new

func respawn():
	var spawn=get_tree().get_first_node_in_group("Spawn")
	#set_missile(false)
	#$Clouds.n=0
	var parent = get_parent()
	parent.remove_child(self)
	position=spawn.position
	velocity=Vector2.ZERO
	enable_collision()
	parent.call_deferred("add_child",self)
	
func disable_collision():
	collision_layer=0
	collision_mask=0
	
func enable_collision():
	collision_layer=2
	collision_mask=3

func squish(squisher):
	velocity+=Vector2.DOWN*50

#func set_clouds(new:int):
	#$Clouds.n=clamp(new,0,3)
#func get_clouds():
	#return $Clouds.n

func spike():
	die()

func die():
	disable_collision()
	var deathTween = get_tree().create_tween()
	deathTween.tween_property($Sprite,"scale",Vector2.ZERO,0.5)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	deathTween.parallel().tween_property($Sprite,"rotation",randf_range(-6,6),0.5)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	deathTween.finished.connect(_on_deathTween_finished)
	dying = true
	$Sprite.play("dying")

func _on_deathTween_finished():
	dying = false
	$Sprite.scale=Vector2.ONE
	$Sprite.rotation=0
	$Sprite.play("sit")
	respawn()
	

func on_goal(goal:Node2D,points:int):
	collision_layer=0
	collision_mask=0
	position=goal.position
	emit_signal("reached_goal")
	hide()
	
