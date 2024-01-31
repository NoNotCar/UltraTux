extends CanvasLayer

@export var gradient: Gradient


func _ready():
	redraw()
	get_viewport().size_changed.connect(redraw)

func redraw():
	var texture = GradientTexture2D.new()
	var sz = get_viewport().get_visible_rect().size
	texture.width = sz.x
	texture.height = sz.y
	texture.gradient = gradient
	texture.fill_to = Vector2(0,1)
	$Background.texture = texture
