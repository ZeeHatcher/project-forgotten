extends TextureRect


signal load_game(index)


export(String) var unselected_text := "Choose an entry from the index."
export(String) var uneventful_text := "Nothing important happened."

var selected := 0
var _saves := []

onready var _item_list := $LeftPage/ItemList
onready var _load_button := $Control/LoadButton
onready var _content_text := $Control/RightPage/ContentText
onready var _audio_open := $AudioOpen
onready var _audio_close := $AudioClose


func _ready():
	_item_list.clear()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("journal"):
		show()


func show() -> void:
	visible = !visible
	_load_button.visible = false
	set_content_text(unselected_text)
	
	if visible:
		_audio_open.play()
	else:
		_audio_close.play()


func set_content_text(text: String) -> void:
	_content_text.text = text
	_content_text.bbcode_text = text


func _load_save(index: int) -> void:
	visible = false
	get_tree().paused = false


func _on_ItemList_item_selected(index):
	print_debug("select " + str(index))
	selected = index
	_load_button.visible = true
	
	var content = ""
	for event in _saves[index].new_completed_events:
		var e = EventRepository.get_event(event)
		if not e.empty():
			content += e.journal_entry + "\n\n"
	
	if content.empty():
		set_content_text(uneventful_text)
	else:
		set_content_text(content)


func _on_GameSaveService_update_saves(saves):
	_item_list.clear()
	for i in range(saves.size()):
		_item_list.add_item("Week " + str(i))
		_item_list.set_item_tooltip_enabled(i, false)
	
	_saves = saves


func _on_GameSaveService_show_journal():
	show()


func _on_LoadSaveLabel_pressed():
	print_debug("loading " + str(selected))
	_load_save(selected)
	emit_signal("load_game", selected)


func _on_JournalButton_pressed():
	show()
