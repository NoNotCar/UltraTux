extends Node

@export var water_level: float
# Called when the node enters the scene tree for the first time.
func _ready():
	if water_level:
		Globals.global_water_level = water_level


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
