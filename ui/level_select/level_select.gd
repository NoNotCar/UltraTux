extends Node

const BLS = preload("res://ui/level_select/bonus_level_select.tscn")
const CLS = preload("res://ui/level_select/classic_level_select.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$Level.load_level("res://levels/title/level_select.lvl")
	if Globals.manifest_mode == "classic":
		$UI.add_child(CLS.instantiate())
	else:
		$UI.add_child(BLS.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
