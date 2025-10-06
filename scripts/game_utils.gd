extends Node

## Hook to get "player" node from scene
func get_player() -> Object :
	var player_node: Node = get_tree().get_first_node_in_group("player")
	if player_node == null:
		push_warning("Oops! Can't get Player from the scene")
		return

	return player_node


## Hook to get nodes of "enemy" from the scene
func get_enemies_array() -> Array:
	var enemies_array: Array = get_tree().get_nodes_in_group("enemy")
	return enemies_array


## Hook to get "foreground" node of the scene
# TODO add hook to set the layer?
func get_foreground() -> Object:
	var foreground_node: Node2D = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_node == null:
		push_warning("Oops! Can't get Foreground layer from the scene")
		return

	return foreground_node


## Hook to get "UserInterface" node from the scene
# TODO add hook to set the layer?
func get_ui() -> Object:
	var ui_node: CanvasLayer = get_tree().get_first_node_in_group("ui_layer")
	if ui_node == null:
		push_warning("Oops! Can't get UI layer from the scene")
		return

	return ui_node


## Hook to get "UserInterface" node from the scene
# TODO add hook to set the layer?
func get_world_overlay() -> Object:
	var ui_node: Node2D = get_tree().get_first_node_in_group("world_overlay")
	if ui_node == null:
		push_warning("Oops! Can't get World Overlay layer from the scene")
		return

	return ui_node


## Disable collisions of CollisionShape2D
func disable_collision(collision_shape_node: CollisionShape2D) -> void :
	if collision_shape_node == null: return

	collision_shape_node.disabled = true


## Get a random point around center: Vector2 within radius: float, isometric if is_isometric is "true"
## Mandatory "radius". Optional: "center", "isometric" is "false" by default
func get_random_point_in_radius(radius: float, center: Vector2 = Vector2.ZERO, isometric: bool = false) -> Vector2:

	var deviation: float = randf_range(0, radius)
	var random_angle: float = randf_range(0.0, TAU)

	var result_position: Vector2 = center + Vector2.from_angle(random_angle) * deviation

	if isometric:
		result_position = IsoUtils.to_isometric_direction(result_position)

	return result_position


func randf_from_seed(_seed: float, variation: float) -> float:
	var deviation: float = randf_range(0.0, variation)
	var result: float = randf_range(_seed - _seed * deviation, _seed + _seed * deviation)
	return result
