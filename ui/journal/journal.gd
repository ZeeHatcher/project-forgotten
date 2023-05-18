extends TextureRect


func show() -> void:
	visible = true
	get_tree().paused = true


func _load_save(index: int) -> void:
	visible = false
	get_tree().paused = false


func _on_ItemList_item_selected(index):
	print_debug("select " + str(index))


func _on_ItemList_item_activated(index):
	print_debug("loading " + str(index))
	_load_save(index)
