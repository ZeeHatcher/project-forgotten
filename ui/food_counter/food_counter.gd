extends HBoxContainer


export(Resource) var food

onready var _counter := $Counter


# Called when the node enters the scene tree for the first time.
func _ready():
	_counter.max_value = food.max_value
	_counter.value = food.value
	food.connect("value_changed", self, "_on_value_changed")


func _on_value_changed() -> void:
	_counter.value = food.value
