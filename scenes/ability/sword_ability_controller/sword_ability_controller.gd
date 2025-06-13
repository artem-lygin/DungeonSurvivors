extends Node

const MAX_RANGE = 150

@export var sword_ability: PackedScene

var damage_amount = 5 #In Firebelly course called 'damage_amount'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	
	if player == null: return
	
	var enemies = get_tree().get_nodes_in_group("enemy") as Array
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
		#return false
	)
	if enemies.size() == 0: return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance=a.global_position.distance_squared_to(player.global_position)
		var b_distance=b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var sword_instance = sword_ability.instantiate() as SwordAbility
	
	if sword_instance == null:
		print("⚠️ SwordInstanse is null")
		return
	
	player.get_parent().add_child(sword_instance)
	
	sword_instance.hitbox_component.damage_amount = damage_amount # In course damage_amount is 'damage'
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()
