extends Control


export(Resource) var resource
export var show_counter := true

onready var _counter := $"%Counter"
onready var _bar := $"%Bar"
onready var _tween := $Tween


func _ready() -> void:
	_bar.max_value = resource.max_value
	_bar.value = resource.value
	resource.connect("value_changed", self, "_on_value_changed")
	
	_counter.max_value = resource.max_value
	_counter.value = resource.value
	
	_counter.visible = show_counter


func _on_value_changed() -> void:
	_tween.interpolate_property(_bar, "value", _bar.value, resource.value, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_tween.start()
	_counter.value = resource.value
