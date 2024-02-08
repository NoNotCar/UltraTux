extends ParallaxLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	reposition()
	get_viewport().size_changed.connect(reposition)
	
func reposition():
	var bounds = get_viewport_rect().size;
	var cam = get_viewport().get_camera_2d()
	var zoom = cam.zoom.x
	motion_offset = Vector2.DOWN * (bounds.y*(motion_scale.y/zoom) + 8)



