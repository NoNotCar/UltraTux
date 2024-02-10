extends EditorTool


const Spikes = preload("res://objects/spikes/spikes.tscn")

func place_drag(spos:Vector2i, epos: Vector2i, l: Layer):
	var delta = epos - spos
	if abs(delta.x) >= abs(delta.y):
		delta.y = 0
	else:
		delta.x =0
	epos = spos + delta
	var placed = l.spawn_object(Spikes, spos)
	if placed:
		placed.right_offset = delta
		placed.place()
