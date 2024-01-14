extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var follow=1
var last_ground=0
var new_ground=0
var target
var player:Player
var arrow:TextureRect
const ARROW_GROW=0.2
const K_OFF = 32.0
var cam_offset = Vector2.ZERO
# Called when the  node enters the scene tree for the first time.
func _ready():
	last_ground=target.position.y
	arrow=$CanvasLayer/Arrow
	var z = max(0.25,lib.nicescale(128/get_viewport().size.y))
	zoom=Vector2.ONE*z

func set_sky_colours(top:Color,bottom:Color):
	var gradient = $Sky/GradientRect
	gradient.material=gradient.material.duplicate()
	gradient.material.set_shader_param("top_colour",top)
	gradient.material.set_shader_param("bottom_colour",bottom)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cam_offset = lerp(cam_offset,player.get_rstick()*K_OFF,5.0*delta)
	if not is_instance_valid(target):
		return
	position=target.position+cam_offset
	var stars=get_tree().get_nodes_in_group("Star")
	if stars:
		var star=stars[0]
		arrow.rect_rotation=rad2deg(Vector2.UP.angle_to(star.position-position))
		if not arrow.visible:
			arrow.rect_scale=Vector2.ZERO
			arrow.visible=true
			$Tween.stop_all()
			$Tween.interpolate_property(arrow,"rect_scale",Vector2.ZERO,Vector2.ONE,ARROW_GROW)
			$Tween.start()
	elif arrow.visible:
		$Tween.stop_all()
		$Tween.interpolate_property(arrow,"rect_scale",arrow.rect_scale,Vector2.ZERO,ARROW_GROW)
		$Tween.interpolate_callback(arrow,ARROW_GROW,"hide")
		$Tween.start()
#	if target.falling:
#		if follow>=1:
#			last_ground=new_ground
#			follow=0
#	elif follow<1:
#		follow+=delta*2
#		new_ground=target.position.y
#	if follow>=1:
#		position=target.position
#		last_ground=target.position.y
#	else:
#		position=Vector2(target.position.x,lerp(last_ground,new_ground,1-pow(1-follow,2)))
