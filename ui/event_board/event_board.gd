class_name EventBoard
extends Control


signal choice_selected(outcome)
signal event_ended(event, complete)

var event: Event setget set_event
var are_conditions_met_handler: FuncRef

onready var _image_bg := $EventImageBG
onready var _image := $"%EventImage"
onready var _title := $"%Title"
onready var _description := $"%Description"
onready var _buttons := $"%Buttons"


func set_event(val: Event) -> void:
	event = val
	_title.text = val.title
	_show_page(0)


func _show_page(idx: int) -> void:
	var page: Event.Page = event.pages[idx]
	_description.text = page.description
	_image.texture = page.image
	_image_bg.visible = page.image != null
	_list_choices(page.choices)


func _list_choices(choices: Array) -> void:
	_reset_choice_list()
	
	if choices.empty():
		var default := Event.Choice.new("Continue...")
		var button := _create_choice_button(default)
		_buttons.add_child(button)		
		return
	
	for choice in choices:
		var button := _create_choice_button(choice)
		_buttons.add_child(button)


func _reset_choice_list() -> void:
	for button in _buttons.get_children():
		button.queue_free()


func _create_choice_button(choice: Event.Choice) -> Button:
	var button := Button.new()
	button.text = choice.description
	button.connect("pressed", self, "_on_choice_selected", [choice])
	button.disabled = not are_conditions_met_handler.call_func(choice.conditions)
	button.align = Button.ALIGN_LEFT
	button.hint_tooltip = choice.help_text if button.disabled else ""
	return button


func _on_choice_selected(choice: Event.Choice) -> void:
	emit_signal("choice_selected", choice.outcome)
	
	if choice.next_page == -1:
		hide()
		emit_signal("event_ended", event, choice.complete)
	else:
		_show_page(choice.next_page)
