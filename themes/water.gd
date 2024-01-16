
extends Node2D

@export var water_depth: int
static var DEEP_COL = Color8(0,105,170)


func _draw():
	draw_rect(Rect2(-12,0,24,water_depth), DEEP_COL)
