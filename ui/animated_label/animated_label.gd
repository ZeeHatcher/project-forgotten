class_name AnimatedLabel
extends Label


export(String, MULTILINE) var full_text setget set_full_text
export(int, 1000, 10000) var letters_per_second := 5000

var _index = 0
var _time_passed = 0.0

onready var _time_required := 60.0 / letters_per_second


func _process(delta: float) -> void:
	if _index >= full_text.length():
		return
	
	if _time_passed >= _time_required:
		while _time_passed >= _time_required:
			_time_passed -= _time_required
			
			if _index >= full_text.length():
				break
			
			_next_letter()
	else:
		_time_passed += delta


func is_still_animating() -> bool:
	return _index < full_text.length()


func skip() -> void:
	text = full_text
	_index = full_text.length()


func _next_letter():
	text += full_text[_index]
	_index += 1


func set_full_text(val: String) -> void:
	full_text = val
	_index = 0
	text = ""
