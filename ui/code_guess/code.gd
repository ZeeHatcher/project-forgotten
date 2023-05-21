class_name Code
extends Label


var selected := false setget set_selected


func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != BUTTON_LEFT or not event.pressed:
		return
	
	self.selected = !selected
	accept_event()


func set_selected(val: bool) -> void:
	selected = val
	modulate = Color("9c4d3b") if selected else Color.white
