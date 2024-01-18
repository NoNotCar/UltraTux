extends Node


func idiv(a: int, b: int):
	return a/b+1 if a<0 else a/b

func signed_angle(a: float, b: float):
	return Vector2.UP.rotated(a).angle_to(Vector2.UP.rotated(b))
