extends Node2D


onready var _board := $CanvasLayer/CenterContainer/EventBoard
onready var _player := $Player

signal unfog_cell(cell, radius)


func _ready():
	unfog_tilemap(_player.global_position, 2)


func _on_EventTiles_event_triggered(event_name: String):
	get_tree().paused = true
	_board.event = EventRepository.get_event(event_name)
	_board.show()


func _on_EventBoard_event_ended():
	get_tree().paused = false


func unfog_tilemap(global_pos, radius = 0):
	emit_signal("unfog_cell", global_pos, radius)


func _on_Player_moved(new_pos):
	unfog_tilemap(new_pos, 2)


func _on_Player_dead():
	pass # Replace with function body.
