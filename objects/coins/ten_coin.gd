extends Node2D

var collected = false
var number = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



	
func save_data():
	return $NumberSelector.number

func load_data(data):
	if data:
		number = data
		$NumberSelector.number = data

func _on_area_2d_body_entered(body):
	if not collected and body is Tux:
		collected = true
		$CollectSound.play()
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite,"scale",Vector2.ZERO,0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		body.collect_coins(10)
		get_tree().get_first_node_in_group("Game").collect_ten_coin(number)


func _on_collect_sound_finished():
	queue_free()
