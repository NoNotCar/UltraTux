extends EditorTool

@export var scene: PackedScene

func place_single(pos: Vector2i, lvl: Level):
	lvl.spawn_object(scene, pos)

