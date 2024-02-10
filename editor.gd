extends Node2D

var currentTool: EditorTool
var enablePlacing = false
var enableErasing = false
var spos: Vector2i
var on_hotbar = []
var hotbar_names = []
const FILE_DIALOG_SIZE = Vector2(600,400)
const LayerButton = preload("res://ui/layer_button.tscn")

func select_tool(newTool: EditorTool):
	if currentTool:
		currentTool.is_selected = false
	currentTool = newTool
	if not (newTool in on_hotbar or newTool.name in hotbar_names):
		var dupe = newTool.duplicate()
		$UI/Hotbar.add_child(dupe)
		on_hotbar.append(dupe)
		dupe.is_selected = true
		currentTool = dupe
		dupe.connect("selected", func (): select_tool(dupe))
		hotbar_names.append(newTool.name)
		if len(on_hotbar) > 10:
			$UI/Hotbar.remove_child(on_hotbar.pop_front())
			hotbar_names.pop_front()
	else:
		newTool.is_selected = true
	$UI/FullTools.hide()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.current_level:
		$Level.load_level(Globals.current_level)
	else:
		$Level.load_empty()
	for tool in get_tree().get_nodes_in_group("Tools"):
		tool.connect("selected", func (): select_tool(tool))
	for layer in $Level.layers:
		setup_layer_button(layer)

func setup_layer_button(layer:int):
	var newButton = LayerButton.instantiate()
	newButton.layer_number = layer
	newButton.connect("pressed", func(): switch_layer(layer))
	$UI/Layers.add_child(newButton)
	$UI/Layers.move_child(newButton, layer-1)

func switch_layer(to: int):
	$Level.switch_layer(to)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mpos = Lib.grid_pos(get_global_mouse_position())
	if enablePlacing and Input.is_action_pressed("editor_place") and currentTool:
		currentTool.place_multi(mpos, $Level.current_layer)
	elif enableErasing and Input.is_action_pressed("editor_erase"):
		$Level.current_layer.clear_terrain(mpos)
	var dx = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var dy = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	$Camera2D.position = $Camera2D.get_screen_center_position() + Vector2(dx,dy) * delta * 128
		
func _unhandled_input(event):
	if event.is_action_pressed("editor_place"):
		enablePlacing = true
		if currentTool:
			spos = Lib.grid_pos(get_global_mouse_position())
			currentTool.place_single(spos, $Level.current_layer)
	elif event.is_action_pressed("editor_erase"):
		enableErasing = true
	elif event.is_action_released("editor_place") and enablePlacing:
		enablePlacing = false
		var epos = Lib.grid_pos(get_global_mouse_position())
		if currentTool and spos != null and spos != epos:
			currentTool.place_drag(spos, epos, $Level.current_layer)
	elif event.is_action_released("editor_erase"):
		enableErasing = false
		
	


func _on_play_gui_input(event):
	if event.is_action_pressed("editor_place") and get_tree().get_first_node_in_group("Spawn"):
		var fname = "user://temp.lvl"
		$Level.save(fname)
		Globals.current_level = fname
		Globals.editing = false
		get_tree().change_scene_to_file("res://game.tscn")
		


func _on_save_gui_input(event):
	if event.is_action_pressed("editor_place"):
		$UI/SaveDialog.popup_centered(FILE_DIALOG_SIZE)


func _on_open_gui_input(event):
	if event.is_action_pressed("editor_place"):
		$UI/OpenDialog.popup_centered(FILE_DIALOG_SIZE)


func _on_open_dialog_file_selected(path):
	$Level.load_level(path)
	for button in $UI/Layers.get_children():
		if button != $UI/Layers/AddLayer:
			button.queue_free()
	for layer in $Level.layers:
		setup_layer_button(layer)


func _on_save_dialog_file_selected(path):
	$Level.save(path)


func _on_add_layer_pressed():
	var next_layer = $Level.add_layer()
	if next_layer:
		setup_layer_button(next_layer)
		switch_layer(next_layer)


func _on_switch_theme_gui_input(event):
	if event.is_action_pressed("editor_place"):
		$Level.current_layer.theme = "underwater"
		$Level.current_layer.load_theme()


func _on_more_gui_input(event):
	if event.is_action_pressed("editor_place"):
		$UI/FullTools.show()
