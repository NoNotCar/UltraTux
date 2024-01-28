extends EditorTool

@export var scene: PackedScene
@export var allow_drag = false

func place_single(pos: Vector2i, lvl: Level):
	if not allow_drag:
		lvl.spawn_object(scene, pos)

func place_multi(pos: Vector2i, lvl: Level):
	if allow_drag:
		lvl.spawn_object(scene, pos)
