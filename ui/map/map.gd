extends TextureRect


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		_on_HUD_map_button_pressed()


func _on_HUD_map_button_pressed():
	if $"../../EventService".is_event_completed("Bunker"):
		texture = preload("res://assets/images/map1.png")
	visible = !visible
