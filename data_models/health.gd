class_name Health
extends Resource


signal depleted
signal value_changed

export var max_value: int
export var value: int setget set_value

var last_hit_by: String


func set_value(val: int) -> void:
	var original := value
	value = clamp(val, 0, max_value)
	if value == 0:
		emit_signal("depleted")
	
	if original != value:
		emit_signal("value_changed")


func hit(val: int, source: String) -> void:
	last_hit_by = source
	self.value += val
