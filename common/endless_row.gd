extends Node2D

var to_repeat: Node2D
@export var repeat_every = 16
@export var parallax = 1.0
var spawned = []

func _ready():
	for child in get_children():
		if child is Node2D:
			to_repeat = child
			break
	respawn()
	
func _enter_tree():
	get_viewport().size_changed.connect(respawn)
	
func _exit_tree():
	get_viewport().size_changed.disconnect(respawn)

func respawn():
	for obj in spawned:
		obj.queue_free()
	spawned.clear()
	var bounds = get_viewport_rect().size;
	var sx = -(bounds.x / repeat_every / 2) - 2
	var ex = (bounds.x / repeat_every / 2) + 1
	for tx in range(sx, ex+1):
		if tx:
			var inst = to_repeat.duplicate()
			inst.position = Vector2(tx * repeat_every, 0)
			add_child(inst)
			spawned.append(inst)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var cx = get_viewport().get_camera_2d().get_screen_center_position().x * parallax
	position.x = Lib.idiv(cx, repeat_every) * repeat_every
