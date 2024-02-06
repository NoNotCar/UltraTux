extends TextureRect
class_name EditorTool

signal selected

var is_selected: bool:
	set(value):
		$Selected.visible = value;
	get:
		return $Selected.value

func place_single(_pos: Vector2i, _l: Layer):
	pass
	
func place_multi(_pos: Vector2i, _l: Layer):
	pass

func place_drag(_spos:Vector2i, _epos: Vector2i, _l: Layer):
	pass
	


func _gui_input(event):
	if event.is_action_pressed("editor_place"):
		accept_event()
		emit_signal("selected")
