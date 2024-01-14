extends Node2D

var currentTool: EditorTool
var enablePlacing = false
var enableErasing = false
var mouse_offset = Vector2(8,8)

func select_tool(newTool: EditorTool):
	if currentTool:
		currentTool.is_selected = false
	currentTool = newTool
	newTool.is_selected = true
# Called when the node enters the scene tree for the first time.
func _ready():
	for tool in get_tree().get_nodes_in_group("Tools"):
		tool.connect("selected", func (): select_tool(tool))

func get_grid_pos(pos: Vector2):
	var res = Vector2i((pos + mouse_offset) / 16) 
	if pos.x <= 0:
		res += Vector2i.LEFT
	if pos.y <= 0:
		res += Vector2i.UP
	return res

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mpos = get_grid_pos(get_global_mouse_position())
	if enablePlacing and Input.is_action_pressed("editor_place") and currentTool:
		currentTool.place_multi(mpos, $Level)
	elif enableErasing and Input.is_action_pressed("editor_erase"):
		$Level.clear_terrain(mpos)
		
func _unhandled_input(event):
	if event.is_action_pressed("editor_place"):
		enablePlacing = true
		if currentTool:
			currentTool.place_single(get_grid_pos(get_global_mouse_position()), $Level)
	elif event.is_action_pressed("editor_erase"):
		enableErasing = true
	elif event.is_action_released("editor_place"):
		enablePlacing = false
	elif event.is_action_released("editor_erase"):
		enableErasing = false
		
	
