extends HBoxContainer

@export_enum("x16") var resolution = "x16"
@export var pixel_scale = 1
var number: int:
	set(value):
		number = value
		renumber()

const x16 = preload("res://ui/numerals/numeral16.tscn")
var numbers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	renumber()

func renumber():
	if not get_parent():
		return
	var snum = str(number)
	for i in len(snum):
		var n
		if len(numbers) <= i:
			n = x16.instantiate()
			if (pixel_scale > 1):
				n.custom_minimum_size = Vector2(10,16) * pixel_scale
			add_child(n)
			numbers.append(n)
		else:
			n = numbers[i]
		n.digit = int(snum[i])
	while len(numbers) > len(snum):
		var last = numbers.pop()
		last.queue_free()


