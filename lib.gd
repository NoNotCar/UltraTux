extends Node

const eighth = TAU / 8
const  grid_offset = Vector2(8,8)
func idiv(a: int, b: int):
	return a/b+1 if a<0 else a/b

func signed_angle(a: float, b: float):
	return Vector2.UP.rotated(a).angle_to(Vector2.UP.rotated(b))

func grid_pos(pos: Vector2)->Vector2i:
	var off = (pos + grid_offset)
	var res = Vector2i(off / 16) 
	if off.x <= 0:
		res += Vector2i.LEFT
	if off.y <= 0:
		res += Vector2i.UP
	return res
	
func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(grid_pos(pos) * 16)
	
func int_angle(angle: float):
	angle = fmod(angle, TAU)
	if angle < 0:
		angle += TAU
	if angle < eighth * 7:
		if angle > eighth * 5:
			return 3
		elif angle > eighth * 3:
			return 2
		elif angle > eighth:
			return 1
	return 0
	
func snap_angle(angle: float):
	return int_angle(angle) * (TAU / 4)

const WATER_DAMPING = 0.1
func water_damp(body: CharacterBody2D, delta: float):
	body.velocity *= pow(WATER_DAMPING, delta)
		
	
