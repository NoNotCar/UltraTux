extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gravity=200
var jump=0
var flip=false: set = set_flipped
var falling=true
var missile=false: set = set_missile
var last_falling=true
var starbar=[]
var mat: Material
var can_respawn = true
const death_barrier = 150
const MPOS = Vector2(7.5,4)
const SMOKE_SPEED = 96.0
signal reached_goal
signal perma_dead


func _physics_process(delta):
	#if $DeathTween.is_active() or not visible:
		#$RunSmoke.emitting = false
		#return
	var dx = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var running=Input.is_action_pressed("run")
	$Sprite.speed_scale=1.5 if running else 1.0
	velocity+=Vector2.RIGHT*dx*delta*200*(int(running)+1)*(0.75 if falling else 1.0)
	velocity+=Vector2.DOWN*gravity*delta
	var jump_pressed = Input.is_action_pressed("jump")
	if jump:
		if jump_pressed:
			velocity+=Vector2.UP*45
		jump-=1
	if missile and jump_pressed:
		velocity+=Vector2.UP*gravity*0.5*delta
		$Missile.animation="fire"
	elif missile:
		$Missile.animation="default"
	velocity*=Vector2(pow(0.1,delta),pow(0.5,delta))
	move_and_slide()
	#$RunSmoke.emitting = running and is_on_floor() and abs(velocity.x)>SMOKE_SPEED
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
	#if $DeathTween.is_active() or not visible:
		#return
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
	var pipe=get_tree().get_nodes_in_group("Spawn")[0]
	#set_missile(false)
	#$Clouds.n=0
	get_parent().remove_child(self)
	position=pipe.position
	pipe.to_spawn.append(self)
	velocity=Vector2.ZERO
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
	$DeathTween.interpolate_property($Sprite,"scale",null,Vector2.ZERO,0.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$DeathTween.interpolate_property($Sprite,"rotation",0,randf_range(-6,6),0.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$DeathTween.start()
	$Sprite.play("dying")

func _on_DeathTween_tween_all_completed():
	if can_respawn:
		$Sprite.scale=Vector2.ONE
		$Sprite.rotation=0
		$Sprite.play("sit")
		respawn()
	else:
		emit_signal("perma_dead")
		queue_free()
	

func on_goal(goal:Node2D,points:int):
	collision_layer=0
	collision_mask=0
	position=goal.position
	emit_signal("reached_goal")
	hide()
	
