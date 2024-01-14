extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(0,-10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
