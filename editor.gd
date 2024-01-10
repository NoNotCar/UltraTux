extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_grid_pos(pos: Vector2):
	var res = Vector2i(pos / 16)
	if pos.x < 0:
		res += Vector2i.LEFT
	if pos.y < 0:
		res += Vector2i.UP
	return res

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mpos = get_grid_pos(get_global_mouse_position())
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		$Level.set_terrain(mpos, "snow")
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$Level.clear_terrain(mpos)
