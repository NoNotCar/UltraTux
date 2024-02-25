extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Level.load_level("res://levels/title/level_select.lvl")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
