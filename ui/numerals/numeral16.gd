extends TextureRect

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

@export_range(0,9) var digit = 0:
	set(value):
		digit = value
		texture = textures[value]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



