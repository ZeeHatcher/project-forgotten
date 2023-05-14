class_name Food
extends Resource


signal depleted
signal value_changed

export var counter: int
export var max_value: int
export var value: int setget set_value

var _counter := 0


func consume() -> void:
	_counter += 1
	if _counter == counter:
		self.value -= 1
		_counter = 0


func set_value(val: int) -> void:
	var original := value
	value = clamp(val, 0, max_value)
	if value == 0:
		emit_signal("depleted")
	
	if original != value:
		emit_signal("value_changed")
