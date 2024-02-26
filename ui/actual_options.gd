extends VBoxContainer

signal confirmed
# Called when the node enters the scene tree for the first time.
func _ready():
	var options_file = ConfigFile.new()
	options_file.load("user://options.sav")
	$HBoxContainer/Volume.value = options_file.get_value("Sound", "Volume", 80)
	if OS.has_feature("web"):
		$FullScreen.hide()
	else:
		var full_screen = options_file.get_value("Video", "Fullscreen", false)
		if full_screen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$FullScreen.button_pressed = full_screen


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_confirm_pressed():
	var options_file = ConfigFile.new()
	options_file.load("user://options.sav")
	options_file.set_value("Sound", "Volume", $HBoxContainer/Volume.value)
	var full_screen = $FullScreen.button_pressed
	options_file.set_value("Video", "Fullscreen", full_screen)
	if full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	emit_signal("confirmed")


func _on_volume_value_changed(value):
	if value:
		AudioServer.set_bus_mute(0,false)
		AudioServer.set_bus_volume_db(0,value/2-50 if value else 0)
	else:
		AudioServer.set_bus_mute(0,true)
