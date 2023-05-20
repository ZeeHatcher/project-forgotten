extends TextureProgress


export(Resource) var resource

onready var _counter := $"%Counter"


func _ready() -> void:
	max_value = resource.max_value
	value = resource.value
	resource.connect("value_changed", self, "_on_value_changed")
	
	_counter.max_value = resource.max_value
	_counter.value = resource.value


func _on_value_changed() -> void:
	value = resource.value
	_counter.value = resource.value
