extends Node


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
