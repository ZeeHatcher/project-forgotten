class_name Inventory
extends Resource


signal quantity_changed

var _items := {}


func get_all() -> Dictionary:
	return _items


func get(name: String) -> int:
	return _items.get(name, 0)


func add(name: String, qty: int) -> void:
	if _items.has(name):
		_items[name] += qty
	else:
		_items[name] = qty
	_items[name] = max(_items[name], 0)
	emit_signal("quantity_changed")
