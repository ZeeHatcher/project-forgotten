extends Node


const ISOMETRIC_PROJECTION_MATRIX := Transform2D(Vector2(1.0, 0.5), Vector2(-1.0, 0.5), Vector2.ZERO)

var tile_width := Vector2()
var tile_height := Vector2()
var step_distance := 12.0


func to_isometric(vector: Vector2) -> Vector2:
	return ISOMETRIC_PROJECTION_MATRIX.basis_xform(vector)


func step_isometric(vector: Vector2) -> Vector2:
	return to_isometric(vector) * step_distance
