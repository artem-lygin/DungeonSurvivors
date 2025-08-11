extends Node


func get_player() -> Object :
	var player_node: Node = get_tree().get_first_node_in_group("player")
	if player_node == null: return

	return player_node


func get_foreground() -> Object:
	var foreground_node: Node2D = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_node == null: return

	return foreground_node


func get_ui() -> Object:
	var ui_node: Node2D = get_tree().get_first_node_in_group("ui_layer")
	if ui_node == null: return

	return ui_node


func disable_collision(collision_shape_node: CollisionShape2D) -> void :
	if collision_shape_node == null: return

	collision_shape_node.disabled = true
