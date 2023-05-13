extends Node


var tile_width := Vector2()
var tile_height := Vector2()
var step_distance := 12.0


func to_isometric(vector: Vector2) -> Vector2:
	return Vector2(vector.x - vector.y, (vector.x + vector.y) / 2)


func step_isometric(vector2: Vector2) -> Vector2:
	return to_isometric(vector2) * step_distance
