extends Node2D
class_name Level

const layer_scene = preload("res://layer.tscn")
var layers = {}
var pipes = {}
var current_layer: Layer
const SILENT = -100.0

func fade_in():
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate",Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_IN)
	await tween.finished
	$CanvasLayer/ColorRect.visible = false
	
func fade_out():
	var tween = create_tween()
	tween.set_parallel()
	$CanvasLayer/ColorRect.visible = true
	tween.tween_property($CanvasLayer/ColorRect, "modulate",Color.WHITE, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_property($Music, "volume_db", SILENT, 0.5).set_ease(Tween.EASE_OUT)
	await tween.finished
	
func _ready():
	fade_in()

func load_empty():
	for l in layers.values():
		l.queue_free()
	layers.clear()
	current_layer = layer_scene.instantiate()
	layers[1] = current_layer
	add_child(current_layer)
	
func load_level(level: String):
	for l in layers.values():
		l.queue_free()
	layers.clear()
	for p in 11:
		pipes[p] = []
	var f = FileAccess.open(level, FileAccess.READ)
	var flen = f.get_length()
	var objectCache = {}
	var loading_layer: int
	while f.get_position() < flen:
		var thing = f.get_pascal_string()
		if thing.begins_with("layer"):
			current_layer = layer_scene.instantiate()
			loading_layer = int(thing.lstrip("layer"))
			layers[loading_layer] = current_layer
			current_layer.theme = f.get_pascal_string()
		elif thing.ends_with(".tscn"):
			var scene = objectCache.get(thing, load(thing))
			objectCache[thing] = scene
			var inst = current_layer.spawn_object(scene, Vector2i(f.get_64(), f.get_64()))
			var data = f.get_var()
			if inst.has_method("load_data"):
				inst.load_data(data)
			if not Globals.editing and inst.has_method("start"):
				inst.start()
			if "pipe_layer" in inst:
				pipes[inst.pipe_layer].append([inst, loading_layer])
		else:
			current_layer.set_terrain(Vector2i(f.get_64(), f.get_64()), thing)
	add_child(layers[1])
	current_layer = layers[1]
	if not Globals.editing:
		$Music.stream = current_layer.music
		$Music.play()


func save(to: String):
	var f = FileAccess.open(to,FileAccess.WRITE)
	for l in layers:
		f.store_pascal_string("layer%s" % l)
		layers[l].save(f)

func add_layer():
	for i in range(1, 10):
		if not layers.has(i):
			var new_layer = layer_scene.instantiate()
			layers[i] = new_layer
			return i

func switch_layer(to: int):
	var to_switch_to = layers.get(to)
	if to_switch_to and to_switch_to != current_layer:
		$Music.stop()
		remove_child(current_layer)
		add_child(to_switch_to)
		current_layer = to_switch_to
		if not Globals.editing:
			$Music.stream = current_layer.music
			$Music.volume_db = 0.0
			$Music.play()
	return current_layer
		
	
	

	
