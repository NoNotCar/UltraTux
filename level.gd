extends Node2D
class_name Level

const terrains = {
	"snow": {
		"type": "ut",
		"id": 1,
		"variants": 3
	},
	"bluepipe": {
		"type": "pipe",
		"id": 0,
		"sticky": true
	}
}

const pipe_connect = [[Vector2i.UP, 1], [Vector2i.RIGHT, 2], [Vector2i.DOWN, 4], [Vector2i.LEFT, 8]]

var terrain = {}
var to_fix = {}
var objects = {}
var music: AudioStream
var theme = "antarctic"
var theme_instance: Node

signal loaded

func load_theme():
	if theme_instance:
		theme_instance.queue_free()
	var scene = Globals.load_theme(theme)
	theme_instance = scene.instantiate()
	add_child(theme_instance)
	music = theme_instance.music

func _ready():
	if Globals.current_level:
		var f = FileAccess.open(Globals.current_level, FileAccess.READ)
		var flen = f.get_length()
		var objectCache = {}
		while f.get_position() < flen:
			var thing = f.get_pascal_string()
			if thing.begins_with("layer"):
				theme = f.get_pascal_string()
				load_theme()
			elif thing.ends_with(".tscn"):
				var scene = objectCache.get(thing, load(thing))
				objectCache[thing] = scene
				var inst = spawn_object(scene, Vector2i(f.get_64(), f.get_64()))
				var data = f.get_var()
				if inst.has_method("load_data"):
					inst.load_data(data)
				if not Globals.editing and inst.has_method("start"):
					inst.start()
			else:
				set_terrain(Vector2i(f.get_64(), f.get_64()), thing)
	if not theme_instance:
		load_theme()
	emit_signal("loaded")
			

func set_terrain(pos: Vector2i, name: String):
	if !terrains.has(name): return
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

func terrain_connected(pos: Vector2i, target: String):
	var dest = terrain.get(pos)
	var info = terrains.get(target)
	return dest if info.get("sticky") else dest == target

func update_terrain(pos: Vector2i):
	var t = terrain.get(pos)
	var info = terrains.get(t)
	if !t:
		$Terrain16.set_cell(0, pos)
	elif info.type == "pipe":
		var i = 0
		for c in pipe_connect:
			if terrain_connected(pos + c[0], t):
				i += c[1]
		$Terrain16.set_cell(0, pos, info.id, Vector2i(i%4, i/4))
		return
	for x in 2:
		for y in 2:
			var tpos = pos * 2 + Vector2i(x,y) - Vector2i.ONE
			if !t:
				$Terrain8.set_cell(0,tpos)
			elif info.type == "ut":
				var i = 0
				var v = Vector2i.RIGHT * (x * 2 - 1)
				var h = Vector2i.DOWN * (y * 2 - 1)
				if terrain_connected(pos + v, t):
					i += 1
				if terrain_connected(pos + h, t):
					i += 2
				if i == 3 and terrain_connected(pos + v + h, t):
					for _v in info.get("variants", 1):
						i += 1;
						if randf() > 0.2:
							break
				$Terrain8.set_cell(0,tpos,info.id,Vector2i(i*2 + x, y))

func spawn_object(scene: PackedScene, pos: Vector2i):
	if not objects.has(pos):
		var instance = scene.instantiate()
		instance.position = pos * 16
		add_child(instance)
		objects[pos] = instance;
		return instance

func save(to: String):
	var f = FileAccess.open(to,FileAccess.WRITE)
	f.store_pascal_string("layer1")
	f.store_pascal_string(theme)
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
		
	
	

	
