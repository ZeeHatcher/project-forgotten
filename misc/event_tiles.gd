extends TileMap
class_name EventTiles


signal event_triggered(event_name)


func trigger_event_at(global_pos: Vector2) -> void:
	var local_position := to_local(global_pos)
	var map_position := world_to_map(local_position)
	var tile_id := get_cellv(map_position)
	var tile_type := tile_set.tile_get_name(tile_id)
	emit_signal("event_triggered", tile_type)
