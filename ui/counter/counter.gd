extends HBoxContainer


export(Texture) var icon_texture
export var max_value: int
export var value: int setget set_value

onready var _icon := $Icon
onready var _label := $Label


func _ready() -> void:
	_icon.texture = icon_texture

func set_value(val: int) -> void:
	value = clamp(val, 0, max_value)
	_label.text = "%s/%s" % [value, max_value]
