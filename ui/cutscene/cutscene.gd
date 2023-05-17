extends Control


signal end()

export(Array, Resource) var content: Array

var _index := -1
var _frame_controller: FrameController

onready var _image := $"TextureRect"
onready var _label := $"%AnimatedLabel"


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
	
	_frame_controller = FrameController.new(_image, _label, content[_index])


class FrameController:
	var _image: TextureRect
	var _label: AnimatedLabel
	var _frame: CutsceneFrame
	var _index := -1
	
	
	func _init(image: TextureRect, label: AnimatedLabel, frame: CutsceneFrame) -> void:
		_image = image
		_label = label
		_frame = frame
		image.texture = frame.image
	
	
	func next() -> bool:
		if _label.is_still_animating():
			_label.skip()
			return false
		
		_index += 1
		if _index >= _frame.text.size():
			return true
		
		_label.full_text = _frame.text[_index]
		
		return false
