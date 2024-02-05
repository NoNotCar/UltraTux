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
var immersed = false
var mat: Material
var dying = false
var pounding = 0.0
var entering_pipe = false
var pipe_layer: int
var pipe_entry = {}
var current_layer = 1
const death_barrier = 16
const MPOS = Vector2(7.5,4)
const SMOKE_SPEED = 96.0
const GROUND_DAMPING = 0.1
const AIR_DAMPING = 0.5
const SHORE_DAMPING = 0.01
const WATER_DAMPING = 0.1
const WATER_ROTATE_SPEED = 8.0
const FULL_POUND = 0.2

func _physics_process(delta):
	if dying or entering_pipe or not visible:
		$RunSmoke.emitting = false
		return
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	for dir in pipe_entry.keys():
		if input.dot(dir) > 0.5:
			entering_pipe = true
			pipe_layer = pipe_entry[dir]
			$Sprite.animation="float"
			$Sprite.rotation = Vector2.UP.angle_to(dir)
			$Pipe.play()
			var snapped_pos = Lib.snap_to_grid(position)
			var tween = create_tween()
			tween.tween_property(self, "position", snapped_pos + dir * 16, 0.5).from(snapped_pos).set_ease(Tween.EASE_IN)
			var best_pos = snapped_pos
			var target_exit
			await tween.finished
			for exit in get_tree().get_nodes_in_group("PipeExits"):
				if exit.pipe_layer == pipe_layer and snapped_pos.distance_squared_to(exit.position)\
				 > snapped_pos.distance_squared_to(best_pos):
					target_exit = exit
					best_pos = exit.position
			if target_exit:
				exit_pipe(target_exit)
				return
			# trans-dimensional transport
			var level: Level = get_tree().get_first_node_in_group("Level")
			for p in level.pipes[pipe_layer]:
				if p[1] == current_layer:
					target_exit = p[0]
				else:
					await level.fade_out()
					get_parent().remove_child(self)
					var new_layer = await level.switch_layer(p[1])
					new_layer.add_child(self)
					current_layer = p[1]
					level.fade_in()
					exit_pipe(p[0])
					return
			if target_exit:
				exit_pipe(target_exit)
				return
			push_error("CAN'T ESCAPE THE TUBE!")
	var depth = Globals.get_water_depth(position + Vector2.DOWN * 6)
	var submerge = clamp(depth/8, 0, 1)
	if immersed and not submerge:
		immersed = false
		jump = 2
		$AirCollider.set_deferred("disabled", false)
		$WaterCollider.set_deferred("disabled", true)
		$Sprite.play("jump_up")
		if Input.is_action_pressed("jump"):
			$Jump.play()
	elif not immersed and submerge >= 1:
		immersed = true
		velocity.y *= 0.5
		$AirCollider.set_deferred("disabled", true)
		$WaterCollider.set_deferred("disabled", false)
	var dx = input.x
	var running=Input.is_action_pressed("run")
	$Sprite.speed_scale=1.5 if running else 1.0
	if immersed:
		var ready_to_swim = $Sprite.animation == "float" or not $Sprite.is_playing()
		if ready_to_swim and Input.is_action_pressed("jump"):
			var dir = Vector2.UP.rotated($Sprite.rotation)
			var push = (50 if running else 40) + abs(dir.cross(velocity)) * 0.25
			velocity+= dir*push
			$Sprite.play("swim")
	else:
		var jump_pressed = Input.is_action_pressed("jump")
		if pounding:
			if is_on_floor():
				if (pounding == FULL_POUND):
					$Pound.play()
				pounding = max(pounding-delta, 0)
				if jump_pressed:
					jump=5
					pounding = 0
					$SuperJump.play()
				elif abs(dx)>0.5 and running:
					pounding = 0
					velocity+=Vector2.RIGHT*dx*150
					$SuperRun.play()
			velocity.x *= pow(0.01,delta)
			velocity+=Vector2.DOWN*gravity*delta*(1-submerge)*2
		elif input.y > 0.5 and not jump and not is_on_floor():
			pounding = FULL_POUND
			velocity+=Vector2.DOWN*55
		if !pounding:
			velocity+=Vector2.RIGHT*dx*delta*200*(int(running)+1)*(0.75 if falling else 1.0)
			velocity+=Vector2.DOWN*gravity*delta*(1-submerge)
			if !jump and jump_pressed and is_on_floor():
				jump=4
				$Jump.play()
			if jump:
				if jump_pressed:
					velocity+=Vector2.UP*55
				jump-=1
			if missile and jump_pressed:
				velocity+=Vector2.UP*gravity*0.5*delta
				$Missile.animation="fire"
			elif missile:
				$Missile.animation="default"
	$RunSmoke.emitting = not submerge and (pounding or (running and is_on_floor() and abs(velocity.x)>SMOKE_SPEED))
	var x_damp = lerp(GROUND_DAMPING, WATER_DAMPING if immersed else SHORE_DAMPING, submerge)
	var y_damp = lerp(AIR_DAMPING, WATER_DAMPING, submerge)
	velocity*=Vector2(pow(x_damp,delta),pow(y_damp,delta))
	move_and_slide()
	for s in get_slide_collision_count():
		var coll = get_slide_collision(s)
		var normal = coll.get_normal()
		var collider = coll.get_collider()
		var is_down = normal.dot(Vector2.UP)>0.5
		if is_down and pounding and collider.has_method("pound"):
			collider.pound(self)
			pounding = 0 if input.y < 0.5 else FULL_POUND
			if not pounding:
				$Pound.play()
		elif is_down and collider.has_method("squish"):
			collider.squish(self)
			if not (jump or pounding):
				velocity+=Vector2.UP*40
				jump=3
		elif normal.dot(Vector2.DOWN)>0.5 and collider.has_method("bash"):
			collider.bash(self)
			velocity+=Vector2.DOWN*20
			$Pound.play()
		elif "hurts" in collider:
			spike()
			return
	var f=not is_on_floor()
	falling = f and last_falling
	last_falling=f
	if immersed:
		pounding = 0
		var tr = null
		if (input.length_squared() > 0.1):
			tr = Vector2.UP.angle_to(input)
			var da = Lib.signed_angle($Sprite.rotation, tr)
			if delta * WATER_ROTATE_SPEED > abs(da):
				$Sprite.rotation = tr;
			else:
				$Sprite.rotate(delta * sign(da) * WATER_ROTATE_SPEED)
		if ($Sprite.animation != "swim"):
			$Sprite.animation="float"
			if tr != null:
				$Sprite.rotation = tr
	else:
		$Sprite.rotation = 0
		set_flipped(dx<0)
		if pounding:
			$Sprite.animation = "pound"
		elif falling:
			$Sprite.animation="jump_up" if velocity.y<0 else "jump_down"
		elif dx:
			$Sprite.animation="walk"
		else:
			$Sprite.animation="sit"
	if position.y>death_barrier:
		die()
		
func exit_pipe(exit):
	var target_pos = exit.position
	var target_dir = Vector2.DOWN.rotated(exit.rotation)
	var tween = create_tween()
	tween.tween_callback($Sprite.set_rotation.bind(Vector2.DOWN.angle_to(target_dir)))
	tween.tween_property(self, "position", target_pos, 0.5).from(target_pos + target_dir * 16)
	await tween.finished
	entering_pipe = false
	velocity = Vector2.ZERO
	pounding = false
	
	
#func _input(event):
	#if dying or not visible:
		#return
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

func collect_coins(coins: int):
	Globals.coins += coins
	if Globals.coins >= 100:
		Globals.coins -= 100
		Globals.lives += 1

func _on_deathTween_finished():
	Globals.lives -= 1
	if Globals.lives:
		get_tree().change_scene_to_file("res://ui/classic_info_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://ui/game_over.tscn")
	

func on_goal(goal:Node2D,points:int):
	collision_layer=0
	collision_mask=0
	position=goal.position
	emit_signal("reached_goal")
	hide()
	
