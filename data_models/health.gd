class_name Health
extends Resource


signal depleted

export(int) var max_value
export(int) var value setget set_value


func set_value(val: int) -> void:
	value = clamp(val, 0, max_value)
	if value == 0:
		emit_signal("depleted")
