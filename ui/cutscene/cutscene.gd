extends Control


signal end()

export(Array, Resource) var content: Array

var _index := -1
var _frame_controller: FrameController

onready var _image := $"TextureRect"
onready var _title := $"%Title"
onready var _title_container := $"PanelContainer"
onready var _label := $"%AnimatedLabel"
onready var _portrait := $"%Portrait"


func play() -> void:
	next()


func _input(event: InputEvent) -> void:
	var is_pressed: bool = (
			(event is InputEventMouseButton or event is InputEventKey)
			and event.pressed
	)
	
	if is_pressed:
		next()
	
	get_tree().set_input_as_handled()


func next() -> void:
	if not _frame_controller:
		_next_frame()
	else:
		var completed := _frame_controller.next()
		if completed:
			_next_frame()


func _next_frame() -> void:
	_index += 1
	if _index >= content.size():
		emit_signal("end")
		return
	
	_frame_controller = FrameController.new(_image, _title, _title_container, _label, _portrait, content[_index])


class FrameController:
	var _image: TextureRect
	var _title: Label
	var _title_container: Control
	var _label: AnimatedLabel
	var _portrait: TextureRect
	var _frame: CutsceneFrame
	var _index := -1
	
	
	func _init(image: TextureRect, title: Label, title_container: Control, label: AnimatedLabel, portrait: TextureRect, frame: CutsceneFrame) -> void:
		_image = image
		_title = title
		_title_container = title_container
		_label = label
		_frame = frame
		_portrait = portrait
		image.texture = frame.image
		
		next()
	
	
	func next() -> bool:
		if _label.is_still_animating():
			_label.skip()
			return false
		
		_index += 1
		if _index >= _frame.text.size():
			return true
		
		var text: Array = _frame.text[_index].split(":", true, 1)
		
		if text.size() > 1:
			_title.visible = true
			_portrait.visible = true
			
			var index = int(text[0])
			_title.text = _frame.character_name[index]
			_portrait.texture = _frame.character_portrait[index]
			_label.full_text = text[1]
		else:
			_title.visible = false
			_portrait.visible = false
			_label.full_text = _frame.text[_index]
		
		print(_title.get_total_character_count(), _title.text)
		_title_container.visible = not _title.text.empty()
		
		return false
