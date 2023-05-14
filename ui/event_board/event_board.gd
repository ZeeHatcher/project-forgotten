class_name EventBoard
extends TabContainer


signal choice_selected(outcome)
signal event_ended

var event: Event setget set_event
var are_conditions_met_handler: FuncRef

onready var _container := $VBoxContainer
onready var _description := $VBoxContainer/EventDescription
onready var _buttons := $VBoxContainer/Buttons


func set_event(val: Event) -> void:
	event = val
	_container.name = val.title # Setting node name also changes tab name
	_show_page(0)


func _show_page(idx: int) -> void:
	var page: Event.Page = event.pages[idx]
	_description.text = page.description
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
	return button


func _on_choice_selected(choice: Event.Choice) -> void:
	emit_signal("choice_selected", choice.outcome)
	
	if choice.next_page == -1:
		hide()
		emit_signal("event_ended")
	else:
		_show_page(choice.next_page)
