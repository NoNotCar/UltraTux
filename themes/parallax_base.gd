extends ParallaxLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	reposition()
	get_viewport().size_changed.connect(reposition)
	
func reposition():
	var bounds = get_viewport_rect().size;
	# magic numbers but it works
	motion_offset = Vector2.DOWN * (bounds.y*(motion_scale.y/2 - 0.085) + 8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
