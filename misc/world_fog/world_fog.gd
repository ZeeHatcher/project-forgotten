extends Node


export (Array, NodePath) var tilemap_paths

var tilemaps := []
var tilemaps_data = []


func _ready():
	for tilemap_path in tilemap_paths:
		tilemaps.append(get_node(tilemap_path))
	
	for tilemap in tilemaps:
		save_tilemap_data(tilemap)
		fog_tilemap(tilemap)


func save_tilemap_data(tilemap) -> void:
	var tilemap_data = {}
	
	var used_cells = tilemap.get_used_cells()
	for cell in used_cells:
		var tile = tilemap.get_cellv(cell)
		tilemap_data[cell] = tile
	
	tilemaps_data.append(tilemap_data)


func fog_all_tilemap() -> void:
	for tilemap in tilemaps:
		fog_tilemap(tilemap)


func fog_tilemap(tilemap) -> void:
	var used_cells = tilemap.get_used_cells()
	var fog_tile_id = tilemap.tile_set.find_tile_by_name("fog")
	
	for cell in used_cells:
		tilemap.set_cellv(cell, fog_tile_id)


func _on_unfog_cell(global_pos, radius) -> void:
	for i in range(tilemaps.size()):
		var tilemap = tilemaps[i]
		var tilemap_data = tilemaps_data[i]
		
		var local_pos = tilemap.to_local(global_pos)
		var cell_center = tilemap.world_to_map(local_pos)
		var used_cells = tilemap.get_used_cells()
		
		for cell_x in range(cell_center.x - radius, cell_center.x + radius):
			for cell_y in range(cell_center.y - radius, cell_center.y + radius):
				var cell = Vector2(cell_x, cell_y)
				
				if not cell in tilemap_data:
					continue
				
				var manhattan_distance = abs(cell.x-cell_center.x) + abs(cell.y-cell_center.y)
				if manhattan_distance >= radius:
					continue
				
				tilemap.set_cellv(cell, tilemap_data[cell])
