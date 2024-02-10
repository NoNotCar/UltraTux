extends Area2D
class_name PufferBubble

var emitter: Node
var exploded = false
const Explosion = preload("res://common/explosion.tscn")
var velocity: Vector2
const DETONATE_THRESH = 200.0
const WATER_RESISTANCE = 0.3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity *= pow(WATER_RESISTANCE, delta)
	if velocity.length_squared() < DETONATE_THRESH:
		kill()
	else:
		position += velocity * delta
	


func _on_body_entered(body):
	if body != emitter:
		kill()
		
func kill():
	exploded = true
	var exp = Explosion.instantiate()
	exp.position = position
	get_parent().call_deferred("add_child", exp)
	queue_free()
		


func _on_area_entered(area):
	if area is PufferBubble:
		kill()
		
