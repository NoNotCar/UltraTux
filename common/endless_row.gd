extends Node2D

@export var to_repeat: PackedScene
@export var repeat_every = 16
var spawned = []

func _ready():
	respawn()
	get_viewport().size_changed.connect(respawn)

func respawn():
	for obj in spawned:
		obj.queue_free()
	spawned.clear()
	var bounds = get_viewport_rect().size;
	var sx = -(bounds.x / repeat_every / 2) - 1
	var ex = (bounds.x / repeat_every / 2) + 1
	for tx in range(sx, ex+1):
		var inst = to_repeat.instantiate()
		inst.position = Vector2(tx * 16, 0)
		add_child(inst)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = Lib.idiv(get_viewport_rect().get_center().x, repeat_every)
