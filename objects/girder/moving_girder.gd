extends AnimatableBody2D

var xv = 0.0
const TAR_V = 32.0
const ACCEL = TAR_V * 10
var active = false

func start():
	active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not active:
		return
	var d = 1 if $SwitchZone.has_overlapping_bodies() else -1
	$Sprite2D.frame = d == 1
	var tv = TAR_V * d
	if d == 1 and $RightCast.is_colliding():
		tv = 0.0
	elif d == -1 and $LeftCast.is_colliding():
		tv = 0.0
	xv += clamp(tv-xv, -ACCEL * delta, ACCEL * delta)
	position += Vector2(xv * delta, 0)
	
	
	
