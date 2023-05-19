extends Node2D


signal unfog_cell(cell, radius)

var _save

onready var _board := $CanvasLayer/EventBoard
onready var _player := $Player
onready var _top_bar := $CanvasLayer/TopBar
onready var _terrain := $Terrain
onready var _event_tiles := $EventTiles
onready var _event_service := $EventService
onready var _gamesave_service := $GameSaveService


func _ready():
	unfog_tilemap(_player.global_position, 3)
	_gamesave_service.save_game()


func _on_EventTiles_event_triggered(event_name: String):
	get_tree().paused = true
	_board.event = EventRepository.get_event(event_name)
	_board.show()


func _on_EventBoard_event_ended():
	get_tree().paused = false


func unfog_tilemap(global_pos, radius = 0):
	emit_signal("unfog_cell", global_pos, radius)


func _on_Player_moved(new_pos):
	unfog_tilemap(new_pos, 3)


func _on_Player_dead():
	pass # Replace with function body.
