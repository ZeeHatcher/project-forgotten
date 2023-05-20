extends TextureRect


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		_on_HUD_map_button_pressed()


func _on_HUD_map_button_pressed():
	visible = !visible
