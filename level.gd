extends Node2D
class_name Level

const terrain_ids = {
	"snow": 1
}
const variants = {
	"snow": 3
}
var terrain = {}
var objects = {}
func _ready():
	pass

func set_terrain(pos: Vector2i, name: String):
	if !terrain_ids.has(name): return
	if terrain.get(pos) == name: return
	terrain[pos] = name
	for x in range(-1,2):
		for y in range(-1,2):
			update_terrain(pos + Vector2i(x,y))

func clear_terrain(pos: Vector2i):
	var obj = objects.get(pos)
	if obj:
		obj.queue_free()
		objects.erase(pos)
	if !terrain.has(pos): return
	terrain.erase(pos)
		
	for x in range(-1,2):
		for y in range(-1,2):
			update_terrain(pos + Vector2i(x,y))

func update_terrain(pos: Vector2i):
	var t = terrain.get(pos)
	for x in 2:
		for y in 2:
			var tpos = pos * 2 + Vector2i(x,y) - Vector2i.ONE
			if !t:
				$Terrain.set_cell(0,tpos)
			else:
				var i = 0
				var v = Vector2i.RIGHT * (x * 2 - 1)
				var h = Vector2i.DOWN * (y * 2 - 1)
				if terrain.get(pos + v):
					i += 1
				if terrain.get(pos + h):
					i += 2
				if i == 3 and terrain.get(pos + v + h):
					for _v in variants.get(t, 1):
						i += 1;
						if randf() > 0.2:
							break
				$Terrain.set_cell(0,tpos,terrain_ids[t],Vector2i(i*2 + x, y))

func spawn_object(scene: PackedScene, pos: Vector2i):
	var instance = scene.instantiate()
	instance.position = pos * 16
	add_child(instance)
	objects[pos] = instance;
	
	

	
