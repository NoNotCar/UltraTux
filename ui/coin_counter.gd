extends HBoxContainer

var current_coins = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_coins != Globals.coins:
		current_coins += 1
		current_coins %= 100
		$Tens.digit = current_coins / 10
		$Ones.digit = current_coins % 10
