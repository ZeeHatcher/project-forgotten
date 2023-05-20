extends Node2D


signal unfog_cell(cell, radius)

var _save

onready var _board := $CanvasLayer/EventBoard
onready var _player := $Player
onready var _terrain := $Terrain
onready var _event_tiles := $EventTiles
onready var _event_service := $EventService
onready var _gamesave_service := $GameSaveService
onready var _journal := $"%Journal"
onready var _inventory := $"%InventoryList"
onready var _hud := $"%HUD"


func _ready():
	unfog_tilemap(_player.global_position, 3)
	_gamesave_service.save_game()
	_hud.hide_all()
	_inventory.set_process_input(false)
	_journal.set_process_input(false)


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


func _on_EventService_event_function_call(function_name):
	if has_method(function_name):
		call_deferred(function_name)
	elif _hud.has_method(function_name):
		_hud.call_deferred(function_name)


func load_next_level():
	get_tree().change_scene("res://scenes/main/main.tscn")


func _on_HUD_journal_unlocked():
	_journal.set_process_input(true)


func _on_HUD_inventory_unlocked():
	_inventory.set_process_input(true)
