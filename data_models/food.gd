class_name Food
extends Resource


signal depleted

export var counter: int
export var max_value: int
export var value: int setget set_value

var _counter := 0


func consume() -> void:
	_counter += 1
	if _counter == counter:
		value -= 1
		_counter = 0


func set_value(val: int) -> void:
	value = max(val, 0)
	if value == 0:
		emit_signal("depleted")
