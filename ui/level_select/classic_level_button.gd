extends Button

var level: String
var coins: Array
# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Label.text = level
	if coins:
		for c in 3:
			if coins[c]:
				$VBoxContainer/TenCoinDisplay.collect(c+1)
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	Globals.current_level = "res://levels/classic/%s.lvl" % level
	Globals.start_game("res://levels/classic/manifest.json", Globals.GAME_MODE.SINGLE_STAGE)
