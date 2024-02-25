extends Node2D
class_name Level

const layer_scene = preload("res://layer.tscn")
var layers = {}
var pipes = {}
var current_layer: Layer
const SILENT = -100.0
var switch = false
enum PENDING_SWITCH {NONE, TO_FALSE, TO_TRUE}
var pending_switch = PENDING_SWITCH.NONE

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
	layers[1] = set_layer(layer_scene.instantiate())
	
func set_layer(l:Layer):
	add_child(l)
	current_layer = l
	for cam in get_tree().get_nodes_in_group("TuxCam"):
		cam.height_limit = -l.max_height * 16.0 - 8.0 if l.max_height else 0.0
	return l
	
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
		elif thing.ends_with(".tscn") or Registry.objects.has(thing):
			thing = Registry.objects.get(thing, thing)
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
	set_layer(layers[1])
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
		if to_switch_to.music != current_layer.music:
			$Music.stop()
		remove_child(current_layer)
		set_layer(to_switch_to)
		if not Globals.editing and not $Music.playing:
			$Music.stream = current_layer.music
			$Music.volume_db = 0.0
			$Music.play()
	return current_layer
		
func switch_switch():
	pending_switch = PENDING_SWITCH.TO_FALSE if switch else PENDING_SWITCH.TO_TRUE
	
func _process(delta):
	if pending_switch != PENDING_SWITCH.NONE:
		switch = false if pending_switch == PENDING_SWITCH.TO_FALSE else true
		for ss in get_tree().get_nodes_in_group("SwitchStates"):
			ss.change_state(switch)
		pending_switch = PENDING_SWITCH.NONE
		$Switch.play()

	
