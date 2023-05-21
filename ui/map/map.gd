extends TextureRect


onready var _audio_open := $AudioOpen
onready var _audio_close := $AudioClose


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("map"):
		_on_HUD_map_button_pressed()


func _on_HUD_map_button_pressed():
	if $"../../EventService".is_event_completed("Bunker"):
		texture = preload("res://assets/images/map1.png")
	visible = !visible
	
	if visible:
		_audio_open.play()
	else:
		_audio_close.play()
