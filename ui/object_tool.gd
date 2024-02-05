extends EditorTool

@export var scene: PackedScene
@export var allow_drag = false

func place_single(pos: Vector2i, l: Layer):
	if not allow_drag:
		l.spawn_object(scene, pos)

func place_multi(pos: Vector2i, l: Layer):
	if allow_drag:
		l.spawn_object(scene, pos)
