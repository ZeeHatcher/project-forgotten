extends Node2D


signal unfog_cell(cell, radius)

var _save

onready var _board := $CanvasLayer/EventBoard
onready var _player := $Player
onready var _terrain := $Terrain
onready var _event_tiles := $EventTiles
onready var _event_service := $EventService
onready var _gamesave_service := $GameSaveService
onready var _journal := $CanvasLayer/Journal
onready var _inventory := $CanvasLayer/InventoryList
onready var _map := $CanvasLayer/Map
onready var _hud := $CanvasLayer/HUD
onready var _animation_player := $AnimationPlayer


func _ready():
	unfog_tilemap(_player.global_position, 3)
	_gamesave_service.save_game()
	_animation_player.play("fade_in")


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
	var reason: String = _player.health.last_hit_by
	var event := "death_%s" % reason
	
	_event_service.start_event(event)
	

func _on_GameOverService_game_over():
	get_tree().paused = true
	_gamesave_service.set_process_input(false)
	_journal.show()
	
	_inventory.set_process_input(false)
	_journal.set_process_input(false)
	_map.set_process_input(false)
	_hud.hide_all()


func _on_Journal_load_game(index):
	get_tree().paused = false
	_gamesave_service.set_process_input(true)
	
	_inventory.set_process_input(true)
	_journal.set_process_input(true)
	_map.set_process_input(true)
	_hud.unlock_all()


func _on_GameOverService_won():
	_animation_player.play("fade_out")


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"fade_out":
			get_tree().change_scene("res://scenes/game_end/game_end.tscn")
