extends EditorTool

@export var terrain = ""
# Called when the node enters the scene tree for the first time.
func place_multi(pos: Vector2i, l: Layer):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		l.set_terrain(pos, terrain)
