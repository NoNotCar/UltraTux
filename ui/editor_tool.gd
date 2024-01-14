extends TextureRect
class_name EditorTool

signal selected

var is_selected: set = set_selected, get = get_selected;

func place_single(pos: Vector2i, lvl: Level):
	pass
	
func place_multi(pos: Vector2i, lvl: Level):
	pass

func place_drag(spos:Vector2i, epos: Vector2i, lvl: Level):
	pass
	
func set_selected(new: bool):
	$Selected.visible = new;

func get_selected():
	return $Selected.visible


func _gui_input(event):
	if event.is_action_pressed("editor_place"):
		accept_event()
		emit_signal("selected")
