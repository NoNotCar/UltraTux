extends Control

static var levelRegex = RegEx.create_from_string("(\\d)-(\\d)")
const game = preload("res://game.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var result = levelRegex.search(Globals.current_level)
	if result:
		$CenterContainer/VBoxContainer/Level/WorldDigit.digit = int(result.get_string(1))
		$CenterContainer/VBoxContainer/Level/LevelDigit.digit = int(result.get_string(2))
	$CenterContainer/VBoxContainer/Lives/Number.number = Globals.lives


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	get_tree().change_scene_to_packed(game)
