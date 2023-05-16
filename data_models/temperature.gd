class_name Temperature
extends Resource


signal depleted
signal value_changed
signal take_cold_damage

export var cold_tickrate: int
export var damage_tickrate: int
export var max_value: int
export var value: int setget set_value
export var percentage: int setget , get_temperature_percentage


var cold_tick = 0
var damage_tick = 0


func tick() -> void:
	cold_tick += 1
	
	if cold_tick >= cold_tickrate:
		set_value(value - 1)
		cold_tick = 0
	
	if value <= 0: 
		damage_tick += 1
	else:
		damage_tick = 0
	
	if damage_tick > damage_tickrate:
		damage_tick = 0
		emit_signal("take_cold_damage")


func set_value(val: int) -> void:
	var original := value
	value = clamp(val, 0, max_value)
	if value == 0:
		emit_signal("depleted")
	
	if original != value:
		emit_signal("value_changed")


func reset() -> void:
	set_value(max_value)


func get_temperature_percentage():
	var temp_percentage = float(value) / max_value
	return temp_percentage
