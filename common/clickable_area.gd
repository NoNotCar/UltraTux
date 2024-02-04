extends Area2D

signal hover_changed(value: String)
signal pressed

var hovered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	hovered = true
	emit_signal("hover_changed", true)


func _on_mouse_exited():
	hovered = false
	emit_signal("hover_changed", false)


func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("editor_place"):
		if hovered:
			get_viewport().set_input_as_handled()
			emit_signal("pressed")
