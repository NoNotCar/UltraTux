extends AcceptDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch(to: String):
	var lvl: Level = get_tree().get_first_node_in_group("Level")
	var cl = lvl.current_layer
	cl.theme = to
	cl.load_theme()

func _on_antarctic_pressed():
	switch("antarctic")


func _on_antarctic_night_pressed():
	switch("antarctic_night")


func _on_cave_pressed():
	switch("cave")


func _on_undersea_pressed():
	switch("underwater")


func _on_castle_pressed():
	switch("castle")


func _on_cloud_night_pressed() -> void:
	switch("cloud_night")
