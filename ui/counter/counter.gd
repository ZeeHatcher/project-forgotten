class_name Counter
extends Label


export var max_value: int
export var value: int setget set_value


func set_value(val: int) -> void:
	value = clamp(val, 0, max_value)
	text = "%s/%s" % [value, max_value]
