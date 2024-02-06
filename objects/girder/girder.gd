extends Node2D

var right_offset: Vector2
# Called when the node enters the scene tree for the first time.
func place():
	$RightTerminus.position = right_offset
	var goff = right_offset + Vector2(8,0)
	$Girder.rotation = Vector2.RIGHT.angle_to(goff)
	$Girder.position = Vector2(-4,-8) + goff / 2 + Vector2.DOWN.rotated($Girder.rotation) * 6
	var rect = Rect2(0,0,goff.length(),12)
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = rect.size
	$Girder/CollisionShape2D.shape = rect_shape
	
	var bleed = 12 * tan($Girder.rotation)
	$Girder/Sprite.region_rect = Rect2(rect.position, rect.size + Vector2(abs(bleed),0))
	$Girder/Sprite.offset = Vector2(-rect.size.x/2 + min(bleed, 0),-6)
	


func save_data():
	return right_offset
	
func load_data(data: Vector2):
	right_offset = data
	place()
