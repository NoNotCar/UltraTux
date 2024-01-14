extends Node2D
class_name Level

const terrain_ids = {
	"snow": 1
}
const variants = {
	"snow": 3
}
var terrain = {}
var to_fix = {}
var objects = {}

signal loaded

func _ready():
	if Globals.current_level:
		var f = FileAccess.open(Globals.current_level, FileAccess.READ)
		var flen = f.get_length()
		var objectCache = {}
		while f.get_position() < flen:
			var thing = f.get_pascal_string()
			if thing.ends_with(".tscn"):
				var scene = objectCache.get(thing, load(thing))
				objectCache[thing] = scene
				var inst = spawn_object(scene, Vector2i(f.get_64(), f.get_64()))
				var data = f.get_var()
				if inst.has_method("load_data"):
					inst.load_data(data)
				if inst.has_method("start"):
					inst.start()
			else:
				set_terrain(Vector2i(f.get_64(), f.get_64()), thing)
	emit_signal("loaded")
			

func set_terrain(pos: Vector2i, name: String):
	if !terrain_ids.has(name): return
	if terrain.get(pos) == name: return
	terrain[pos] = name
	for x in range(-1,2):
		for y in range(-1,2):
			to_fix[pos + Vector2i(x,y)] = true

func clear_terrain(pos: Vector2i):
	var obj = objects.get(pos)
	if obj:
		obj.queue_free()
		objects.erase(pos)
	if !terrain.has(pos): return
	terrain.erase(pos)
		
	for x in range(-1,2):
		for y in range(-1,2):
			to_fix[pos + Vector2i(x,y)] = true

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
	return instance

func save(to: String):
	var f = FileAccess.open(to,FileAccess.WRITE)
	for t in terrain:
		f.store_pascal_string(terrain[t])
		f.store_64(t.x)
		f.store_64(t.y)
	for o in objects:
		var obj = objects[o]
		f.store_pascal_string(obj.scene_file_path)
		f.store_64(o.x)
		f.store_64(o.y)
		f.store_var(obj.save_data() if obj.has_method("save_data") else null)

func _process(delta):
	for p in to_fix:
		update_terrain(p)
	to_fix.clear()
		
	
	

	
