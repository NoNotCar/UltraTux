extends Node2D

var collected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if not collected and body is Tux:
		collected = true
		$CollectSound.play()
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite,"scale",Vector2.ZERO,0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		body.collect_coins(10)
