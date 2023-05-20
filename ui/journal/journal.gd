extends TextureRect


signal load_game(index)


export(String) var unselected_text := "Choose an entry from the index."
export(String) var uneventful_text := "Nothing important happened."

var selected := 0

onready var _item_list := $LeftPage/ItemList
onready var _load_button := $Control/LoadButton
onready var _content_text := $Control/RightPage/ContentText


func _ready():
	_item_list.clear()


func show() -> void:
	visible = !visible
	get_tree().paused = visible
	_load_button.visible = false
	_content_text.text = unselected_text
	_content_text.bbcode_text = unselected_text


func _load_save(index: int) -> void:
	visible = false
	get_tree().paused = false


func _on_ItemList_item_selected(index):
	print_debug("select " + str(index))
	selected = index
	_load_button.visible = true
	
	_content_text.text = uneventful_text
	_content_text.bbcode_text = uneventful_text


func _on_GameSaveService_update_saves(save_count):
	_item_list.clear()
	for i in range(save_count):
		_item_list.add_item("Week " + str(i))


func _on_GameSaveService_show_journal():
	show()


func _on_LoadSaveLabel_pressed():
	print_debug("loading " + str(selected))
	_load_save(selected)
	emit_signal("load_game", selected)


func _on_JournalButton_pressed():
	pass # Replace with function body.
