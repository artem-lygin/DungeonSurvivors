@abstract
class_name IsoUtils extends Node


const ISOMETRIC_MODE: = true # if TRUE going to return recalculated Vectors2, if FALSE will return input Vector2
const ISOMETRIC_RATIO: = Vector2(1, 0.5)

static func to_isometric_direction(vector: Vector2) -> Vector2:
	if ISOMETRIC_MODE:
		return vector * ISOMETRIC_RATIO
	else:
		return vector

static func from_isometric_direction(vector: Vector2) -> Vector2: # Optional: inverse transform (e.g. from screen-space to world-space direction)
	return Vector2(vector.x, vector.y * 2)

static func to_isometric_length(vector: Vector2) -> Vector2:
	if ISOMETRIC_MODE:
		if not vector.is_normalized():
			vector = vector.normalized()
		var iso_vector: Vector2 = vector * ISOMETRIC_RATIO
		var iso_scale: float = sqrt(pow(iso_vector.x, 2) + pow(iso_vector.y, 2))
		return vector * iso_scale
	else:
		return vector
