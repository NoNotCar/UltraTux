extends Node2D

enum MODE {ENTRY_ONLY, EXIT_ONLY, ENTRY_EXIT}
var mode = MODE.ENTRY_EXIT
var pipe_layer = 0
var dir = Vector2.DOWN
# Called when the node enters the scene tree for the first time.
func _ready():
	if mode:
		add_to_group("PipeExits")
	if not mode % 2:
		add_to_group("PipeEntrances")
	if not Globals.editing:
		$ModeSprite.queue_free()
		$Toggle.queue_free()




func save_data():
	return [0, mode, $NumberSelector.number]
	
func load_data(data: Array):
	mode = data[1]
	$ModeSprite.frame = data[1]
	pipe_layer = data[2]
	$NumberSelector.number = data[2]

func _on_toggle_pressed():
	mode += 1
	mode %= 3
	$ModeSprite.frame = mode
	



func _on_active_area_body_entered(body):
	if body is Tux and not mode % 2:
		body.pipe_entry[dir] = pipe_layer


func _on_active_area_body_exited(body):
	if body is Tux and not mode % 2:
		body.pipe_entry.erase(dir)
