extends Button

const textures = [
	preload("res://ui/numerals/numerals16_1.png"),
	preload("res://ui/numerals/numerals16_2.png"),
	preload("res://ui/numerals/numerals16_3.png"),
	preload("res://ui/numerals/numerals16_4.png"),
	preload("res://ui/numerals/numerals16_5.png"),
	preload("res://ui/numerals/numerals16_6.png"),
	preload("res://ui/numerals/numerals16_7.png"),
	preload("res://ui/numerals/numerals16_8.png"),
	preload("res://ui/numerals/numerals16_9.png"),
	preload("res://ui/numerals/numerals16_10.png"),
]

var layer_number = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	icon = textures[layer_number]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
