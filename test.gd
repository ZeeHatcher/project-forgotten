extends Node2D


onready var _board := $CanvasLayer/CenterContainer/EventBoard


func _on_EventTiles_event_triggered(event_name: String):
	get_tree().paused = true
	_board.event = EventRepository.get_event(event_name)
	_board.show()


func _on_EventBoard_event_ended():
	get_tree().paused = false
