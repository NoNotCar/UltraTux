extends Node2D

var right_offset: Vector2i
# Called when the node enters the scene tree for the first time.

func place():
	var length = right_offset.length() * 16
	$RightCap.position =  Vector2.RIGHT * length
	rotation = Vector2.RIGHT.angle_to(right_offset)
	$Middle.region_rect = Rect2(0, 0, length + 8, 16)
	if not Globals.editing:
		var body = StaticBody2D.new()
		var cs = CollisionShape2D.new()
		var rs = RectangleShape2D.new()
		rs.size = Vector2(length + 16, 5)
		cs.shape = rs
		body.position = Vector2(length / 2, 5.5)
		add_child(body)
		body.add_child(cs)
		
		var area = Area2D.new()
		var acs = CollisionShape2D.new()
		var ps = ConvexPolygonShape2D.new()
		ps.points = PackedVector2Array([Vector2(-1,-8),Vector2(length,-8), Vector2(length + 4, 3), Vector2(-5, 3)])
		acs.shape = ps
		add_child(area)
		area.add_child(acs)
		area.collision_layer = 7
		area.collision_mask = 7
		area.body_entered.connect(spike)
		area.area_entered.connect(spike)


func spike(body):
	if body.has_method("kill"):
		body.call_deferred("kill")

func save_data():
	return right_offset
	
func load_data(data: Vector2):
	right_offset = data
	place()
