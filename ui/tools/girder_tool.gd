extends EditorTool

const Girder = preload("res://objects/girder/girder.tscn")

func place_drag(spos:Vector2i, epos: Vector2i, l: Layer):
	var delta = epos - spos
	if delta.x < 0:
		spos = epos
		delta *= -1
	if abs(delta.x) < abs(delta.y):
		return
	var girder = l.spawn_object(Girder, spos)
	girder.right_offset = Vector2(delta * 16)
	girder.place()
