extends Node


signal show_journal()
signal update_saves(save_count)

var _save
var save_index := 0
var tiles_moved := 0

export(int) var save_after_tiles_moved := 1

export(NodePath) var player
export(NodePath) var top_bar
export(NodePath) var terrain
export(NodePath) var event_tiles
export(NodePath) var event_service

onready var _player = get_node(player)
onready var _terrain = get_node(terrain)
onready var _top_bar = get_node(top_bar)
onready var _event_tiles = get_node(event_tiles)
onready var _event_service = get_node(event_service)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("journal"):
		emit_signal("show_journal")


func save_game():
	_save = SaveGame.new()
	_save.player_position = _player.target_position
	_save.player_health = _player.health.value
	_save.player_food = _player.food.value
	_save.player_temperature = _player.temperature.value
	_save.inventory_items = _player.inventory.get_all()
	
	_save.terrain = get_tilemap_data(_terrain)
	_save.event_tiles = get_tilemap_data(_event_tiles)
	
	_save.event_flags = _event_service._flags
	_save.event_completed = _event_service._completed

	_save.write_savegame(save_index)
	save_index += 1
	
	emit_signal("update_saves", get_save_count())


func load_game(index):
	save_index = index + 1
	_save = SaveGame.load_savegame(index)
	if not _save:
		return
	
	_player.global_position = _save.player_position
	_player.target_position = _save.player_position
	_player.health.value = _save.player_health
	_player.food.value = _save.player_food
	_player.temperature.value = _save.player_temperature
	_player.inventory.set_inventory(_save.inventory_items)
	_player.cancel_movement()
	
	_top_bar.player_health.value  = _save.player_health
	_top_bar.player_food.value = _save.player_food
	
	$"../WorldFog".fog_all_tilemap()
	for tile in _save.terrain:
		_terrain.set_cellv(tile, _save.terrain[tile])
	for tile in _save.event_tiles:
		_event_tiles.set_cellv(tile, _save.event_tiles[tile])
	
	_event_service._flags = _save.event_flags
	_event_service._completed = _save.event_completed
	
	emit_signal("update_saves", get_save_count())


func get_tilemap_data(tilemap) -> Dictionary:
	var tilemap_data = {}
	
	var used_cells = tilemap.get_used_cells()
	for cell in used_cells:
		var tile = tilemap.get_cellv(cell)
		tilemap_data[cell] = tile
	
	return tilemap_data


func get_save_count() -> int:
	return save_index


func _on_Journal_load_game(index):
	load_game(index)


func _on_Player_moved(new_pos):
	tiles_moved += 1
	if tiles_moved >= save_after_tiles_moved:
		tiles_moved = 0
		save_game()


func _on_JournalButton_pressed():
	emit_signal("show_journal")
