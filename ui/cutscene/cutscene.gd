extends Control


signal end()

export(Array, String, MULTILINE) var content: Array

var _index := -1

onready var _label := $CenterContainer/Label
onready var _animation_player := $AnimationPlayer
onready var _timer := $Timer


func play() -> void:
	_next()


func _input(event: InputEvent) -> void:
	var is_mouse_click: bool = (
			event is InputEventMouseButton
			and event.button_index == BUTTON_LEFT
			and event.pressed
	)
	
	if is_mouse_click:
		_timer.stop()
		_next()
	
	get_tree().set_input_as_handled()


func _next():
	_animation_player.play("fade_out")
	_index += 1
	
	yield(_animation_player, "animation_finished")
	_label.text = ""
	
	if _index >= content.size():
		emit_signal("end")
		return
	
	_label.text = content[_index]
	_animation_player.play("fade_in")
	yield(_animation_player, "animation_finished")
	_timer.start()


func _on_Timer_timeout() -> void:
	_next()
