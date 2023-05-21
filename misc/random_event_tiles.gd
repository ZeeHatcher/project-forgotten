class_name RandomEventTiles
extends TileMap


export(int, 0, 100) var trigger_chance
export(NodePath) var _audio_player_path
export(Array, String) var random_events := []
export var grace_period := 5


var tile_sounds := {
	"forest": [
		preload("res://assets/sfx/UX_forest_player_movement_1.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_2.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_3.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_4.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_5.mp3"),
	],
	"trees": [
		preload("res://assets/sfx/UX_forest_player_movement_1.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_2.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_3.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_4.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_5.mp3"),
	],
	"grass": [
		preload("res://assets/sfx/UX_forest_player_movement_1.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_2.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_3.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_4.mp3"),
		preload("res://assets/sfx/UX_forest_player_movement_5.mp3"),
	],
	"mountain": [
		preload("res://assets/sfx/UX_mountain_player_movement_1.mp3"),
		preload("res://assets/sfx/UX_mountain_player_movement_2.mp3"),
		preload("res://assets/sfx/UX_mountain_player_movement_3.mp3"),
		preload("res://assets/sfx/UX_mountain_player_movement_4.mp3"),
		preload("res://assets/sfx/UX_mountain_player_movement_5.mp3"),
	],
	"snow": [
		preload("res://assets/sfx/UX_snow_player_movement_1.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_2.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_3.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_4.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_5.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_6.mp3"),
	],
	"snow_trees": [
		preload("res://assets/sfx/UX_snow_player_movement_1.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_2.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_3.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_4.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_5.mp3"),
		preload("res://assets/sfx/UX_snow_player_movement_6.mp3"),
	]
}


signal event_triggered(event_name)

onready var _grace := grace_period
onready var _audio_player: AudioStreamPlayer = get_node(_audio_player_path)


func trigger_event_at(global_pos: Vector2) -> void:
	if not _can_trigger():
		return
	
	var event_name := _random_event()
	if not event_name:
		return
	
	emit_signal("event_triggered", event_name)
	_grace = grace_period


func _random_event() -> String:
	var events: Array = random_events
	events.shuffle()
	return events.front() if not events.empty() else null


func _can_trigger() -> bool:
	if _grace > 0:
		_grace -= 1
		return false
	
	var roll := randi() % 100 + 1
	return roll <= trigger_chance


func _on_EventService_outcome_applied(outcome: Event.State):
	if not outcome.items.has("climbing_gear"):
		return
		
	var mountain_id = tile_set.find_tile_by_name("mountain")
	print(mountain_id)
	for i in range(tile_set.tile_get_shape_count(mountain_id)):
		tile_set.tile_set_shape(mountain_id, i, null)


func _on_Player_moved(new_pos):
	var local_position := to_local(new_pos)
	var map_position := world_to_map(local_position)
	var tile_id := get_cellv(map_position)
	var tile_type := tile_set.tile_get_name(tile_id)
	
	if tile_sounds.has(tile_type):
		var rand_index:int = randi() % tile_sounds[tile_type].size()
		_audio_player.stream = tile_sounds[tile_type][rand_index]
		_audio_player.play()
