class_name RandomEventTiles
extends TileMap


export(int, 0, 100) var trigger_chance
export var tile_events := {}
export var grace_period := 5

signal event_triggered(event_name)

var _grace := grace_period


func trigger_event_at(global_pos: Vector2) -> void:
	if not _can_trigger():
		return
	
	var local_position := to_local(global_pos)
	var map_position := world_to_map(local_position)
	var tile_id := get_cellv(map_position)
	var tile_type := tile_set.tile_get_name(tile_id)
	
	var event_name := _random_event(tile_type)
	if not event_name:
		return
	
	emit_signal("event_triggered", event_name)
	_grace = grace_period


func _random_event(tile_type: String) -> String:
	var events: Array = tile_events.get(tile_type, [])
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
