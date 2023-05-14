extends Node


export (NodePath) var tilemap_path

var tilemap : TileMap
var tile_data = {}


func _ready():
	tilemap = get_node(tilemap_path)
	
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


func unfog_tiles(cell, radius = 0) -> void:
	tilemap.set_cellv(cell, tile_data[cell])
