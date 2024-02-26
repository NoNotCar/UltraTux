extends Button

var level: String
var coins: Array
# Called when the node enters the scene tree for the first time.
func _ready():
	%Label.text = level.trim_suffix(".lvl").capitalize()
	if coins:
		%Cage.hide()
		for c in 3:
			if coins[c]:
				%TenCoinDisplay.collect(c+1)
	else:
		%TenCoinDisplay.hide()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	Globals.current_level = "%s/%s.lvl" % [Globals.manifest_root, level]
	Globals.start_game( Globals.GAME_MODE.SINGLE_STAGE)
