extends Node

const MAX_RANGE = 150

@export var sword_ability_scene: PackedScene
@export_range (1.0, 100.0) var damage_amount: float = 5 #In Firebelly course called 'damage' and declared as variant

@onready var sword_ability_timer: Timer = $SwordAbilityTimer

# var damage_amount: float = 5 #In Firebelly course called 'damage_amount'
var base_wait_time: float
var max_wait_time_reduction: float = .75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_wait_time = sword_ability_timer.wait_time
	sword_ability_timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)



func on_timer_timeout() -> void:
	@warning_ignore("untyped_declaration")
	var player = get_tree().get_first_node_in_group("player") as Node2D

	if player == null: return

	var enemies: Array = get_tree().get_nodes_in_group("enemy") as Array
	enemies = enemies.filter(
		func (enemy: Node2D) -> bool:
			return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2)
	)
	if enemies.size() == 0: return

	enemies.sort_custom(
		func(a: Node2D, b: Node2D) -> bool:
			var a_distance: float = a.global_position.distance_squared_to(player.global_position)
			var b_distance: float = b.global_position.distance_squared_to(player.global_position)
			return a_distance < b_distance
	)

	@warning_ignore("untyped_declaration")
	var sword_instance = sword_ability_scene.instantiate() as SwordAbility

	if sword_instance == null:
		print("⚠️ SwordInstanse is null")
		return

	@warning_ignore("untyped_declaration")
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer == null: return

	foreground_layer.add_child(sword_instance)

	sword_instance.hitbox_component.damage_amount = damage_amount # In course damage_amount is 'damage'
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction: Vector2 = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if upgrade.id != "sword_rate":
		return

	var percent_reduction: float = current_upgrades["sword_rate"]["quantity"] * .1
	sword_ability_timer.wait_time = max(base_wait_time * (1 - percent_reduction), max_wait_time_reduction)
	sword_ability_timer.start()

	print("⚔️ Sword ability will spawn time is ", sword_ability_timer.wait_time)
