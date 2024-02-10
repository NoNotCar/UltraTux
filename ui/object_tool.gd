extends EditorTool

@export var scene: PackedScene
@export var allow_drag = false
@export var rotate = false
@export_group("Rotation Settings")
@export var base_direction = Vector2.UP

func place_single(pos: Vector2i, l: Layer):
	if not allow_drag and not rotate:
		l.spawn_object(scene, pos)

func place_multi(pos: Vector2i, l: Layer):
	if allow_drag:
		l.spawn_object(scene, pos)
		
func place_drag(spos:Vector2i, epos: Vector2i, l: Layer):
	if rotate:
		var delta = epos - spos
		var rot = 0.0
		if delta:
			rot = Lib.snap_angle(base_direction.angle_to(Vector2(delta)))
		var obj = l.spawn_object(scene, spos)
		if obj:
			obj.rotation = rot
		
	
