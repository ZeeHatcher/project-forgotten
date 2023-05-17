extends Node2D


signal unfog_cell(cell, radius)

var _save

onready var _board := $CanvasLayer/CenterContainer/EventBoard
onready var _player := $Player
onready var _top_bar := $CanvasLayer/TopBar
onready var _terrain := $Terrain
onready var _event_tiles := $EventTiles
onready var _event_service := $EventService

func _ready():
	unfog_tilemap(_player.global_position, 3)


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


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		save_game()
	if Input.is_action_just_pressed("ui_cancel"):
		load_game()


func get_tilemap_data(tilemap) -> Dictionary:
	var tilemap_data = {}
	
	var used_cells = tilemap.get_used_cells()
	for cell in used_cells:
		var tile = tilemap.get_cellv(cell)
		tilemap_data[cell] = tile
	
	return tilemap_data


func save_game():
	_save = SaveGame.new()
	_save.player_position = _player.target_position
	_save.health = _player.health
	_save.food = _player.food
	_save.inventory_items = _player.inventory.get_all()
	_save.temperature = _player.temperature
	
	_save.terrain = get_tilemap_data(_terrain)
	_save.event_tiles = get_tilemap_data(_event_tiles)
	
	_save.event_flags = _event_service._flags
	_save.event_completed = _event_service._completed

	_save.write_savegame()


func load_game():
	_save = SaveGame.load_savegame()
	_player.global_position = _save.player_position
	_player.target_position = _save.player_position
	_player.health = _save.health
	_player.food = _save.food
	_player.inventory._items = _save.inventory_items
	_player.temperature = _save.temperature
	_player.connect_resource_signals()
	_player.cancel_movement()
	
	_top_bar.player_health  = _save.health
	_top_bar.player_food = _save.food
	_top_bar.connect_resource_signals()
	
	for tile in _save.terrain:
		_terrain.set_cellv(tile, _save.terrain[tile])
	for tile in _save.event_tiles:
		_event_tiles.set_cellv(tile, _save.event_tiles[tile])
	
	_event_service._flags = _save.event_flags
	_event_service._completed = _save.event_completed
	print(_save.inventory_items)
