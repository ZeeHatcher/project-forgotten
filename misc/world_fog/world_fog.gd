extends Node


export (NodePath) var tilemap_path

var tilemap : TileMap
var tile_data = {}


func _ready():
	tilemap = get_node(tilemap_path)
	
	if not tilemap:
		return
	
	save_tilemap_data(tilemap)
	fog_tilemap(tilemap)


func save_tilemap_data(tilemap) -> void:
	var used_cells = tilemap.get_used_cells()
	for cell in used_cells:
		var tile = tilemap.get_cellv(cell)
		tile_data[cell] = tile


func fog_tilemap(tilemap) -> void:
	var used_cells = tilemap.get_used_cells()
	for cell in used_cells:
		tilemap.set_cellv(cell, 2)


func _on_unfog_cell(global_pos, radius) -> void:
	var local_position := tilemap.to_local(global_pos)
	var cell_center := tilemap.world_to_map(local_position)
	
	for cell_x in range(cell_center.x - radius, cell_center.x + radius):
		for cell_y in range(cell_center.y - radius, cell_center.y + radius):
			var cell = Vector2(cell_x, cell_y)
			
			if not cell in tile_data:
				continue
			
			var manhattan_distance = abs(cell.x-cell_center.x) + abs(cell.y-cell_center.y)
			if manhattan_distance >= radius:
				continue
				
			tilemap.set_cellv(cell, tile_data[cell])
