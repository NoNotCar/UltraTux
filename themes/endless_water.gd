extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$EndlessRow/Water.water_depth = -position.y + 8
	$EndlessRow.respawn()
	Globals.global_water_level = position.y - 4