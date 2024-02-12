extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	%CreditText.append_text("[center][b]This game uses Godot Engine, available under the following license:[/b]\n" + Engine.get_license_text() + "\n\n[/center]")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rich_text_label_meta_clicked(meta):
	OS.shell_open(str(meta))


func _on_back_pressed():
	get_tree().change_scene_to_file("res://title.tscn")
