extends TextureRect
class_name EditorTool

signal selected

var is_selected: bool:
	set(value):
		$Selected.visible = value;
	get:
		return $Selected.value

func place_single(pos: Vector2i, l: Layer):
	pass
	
func place_multi(pos: Vector2i, l: Layer):
	pass

func place_drag(spos:Vector2i, epos: Vector2i, l: Layer):
	pass
	


func _gui_input(event):
	if event.is_action_pressed("editor_place"):
		accept_event()
		emit_signal("selected")
