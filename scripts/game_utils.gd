extends Node


func get_player() -> Object :
	var player_node: Node = get_tree().get_first_node_in_group("player")
	if player_node == null: return

	return player_node


func disable_collision(collision_shape_node: CollisionShape2D) -> void :
	if collision_shape_node == null: return

	collision_shape_node.disabled = true
