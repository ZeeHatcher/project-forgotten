extends TextureRect


signal load_game(index)

onready var _item_list := $LeftPage/ItemList


func _ready():
	_item_list.clear()


func show() -> void:
	visible = !visible
	get_tree().paused = visible


func _load_save(index: int) -> void:
	visible = false
	get_tree().paused = false


func _on_ItemList_item_selected(index):
	print_debug("select " + str(index))


func _on_ItemList_item_activated(index):
	print_debug("loading " + str(index))
	_load_save(index)
	emit_signal("load_game", index)


func _on_GameSaveService_update_saves(save_count):
	_item_list.clear()
	for i in range(save_count):
		_item_list.add_item("Week " + str(i))


func _on_GameSaveService_show_journal():
	show()
