# iso_utils.gd
extends Node

# Isometric 2:1 ratio
const ISOMETRIC_RATIO := Vector2(1, 0.5)

func to_isometric(vector: Vector2) -> Vector2:
	return vector * ISOMETRIC_RATIO

func from_isometric(vector: Vector2) -> Vector2: # Optional: inverse transform (e.g. from screen-space to world-space direction)
	return Vector2(vector.x, vector.y * 2)
