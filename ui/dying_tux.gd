extends AnimatedSprite2D

var rotation_speed = randf_range(-3,3)
var fall_speed = randf_range(40,60)
# Called when the node enters the scene tree for the first time.
func _ready():
	var vs = get_viewport_rect().size;
	position.x = randf_range(-vs.x/8, vs.x/8)
	position.y = -vs.y/8
	scale = Vector2.ONE * randf_range(0.75,1.25)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += delta * rotation_speed
	position.y += delta * fall_speed


func _on_visible_on_screen_notifier_2d_screen_exited():
	position.y *= -1
	var vsx = get_viewport_rect().size.x;
	position.x = randf_range(-vsx/8, vsx/8)
	rotation_speed = randf_range(-3,3)
	fall_speed = randf_range(40,50)
	scale = Vector2.ONE * randf_range(0.75,1.25)
