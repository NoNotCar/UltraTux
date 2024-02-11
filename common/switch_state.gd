extends Node

signal state_changed(to: bool)

var last_state = false
# Called when the node enters the scene tree for the first time.

func _ready():
	var lvl = get_tree().get_first_node_in_group("Level")
	if lvl:
		change_state(lvl.switch)

func change_state(to: bool):
	if to != last_state:
		emit_signal("state_changed", to)
		last_state = to
