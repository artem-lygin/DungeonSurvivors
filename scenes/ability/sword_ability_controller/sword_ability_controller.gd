extends Node

const MAX_RANGE = 150

@export var sword_ability_scene: PackedScene

@export_group("Sword Damage")
@export_range (1.0, 100.0) var base_damage: float = 5 #In Firebelly course called 'damage' and declared as variant
@export var damage_gain_perc: float = .15 # 10 upgrades result 20 dmg

@export_group("Sword Rate")
@export var base_wait_time: float = 1.5
@export_range (0.0, 1.0) var rate_additional_perc: float = .1 # 10 upgrades result 0.52 cooldown

@export_group("Sword Area")
@export_range (0.0, 100.0) var base_radius: float = 24.0
@export_range (0.0, 1.0) var radius_gain_perc: float = .15 # 10 upgrades result 48 px radius

@export_group("Upgrades IDs")
@export var rate_upgrade: String = "sword_rate"
@export var damage_upgrade: String = "sword_damage"
@export var area_upgrade: String = "sword_area"

@onready var sword_ability_timer: Timer = $SwordAbilityTimer
@onready var sword_ability_collision_shape_node: CollisionShape2D
@onready var sword_ability_collision_shape: CircleShape2D

# var damage_amount: float = 5 #In Firebelly course called 'damage_amount'
var dmg_additional_perc: float = 1
var wait_time_reduction: float = .1
var radius_additional_perc: float = 1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_wait_time = sword_ability_timer.wait_time
	sword_ability_timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout() -> void:
	var player: Node2D = GameUtils.get_player() as Node2D

	if player == null: return

	var enemies: Array = GameUtils.get_enemies_array()
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

	var sword_instance: SwordAbility = sword_ability_scene.instantiate() as SwordAbility
	if sword_instance == null:
		push_error("Oops! Sword ability instanse is null")
		return

	sword_ability_collision_shape_node = sword_instance.get_node("HitboxComponent/CollisionShape2D")
	sword_ability_collision_shape = sword_ability_collision_shape_node.shape as CircleShape2D
	if sword_ability_collision_shape != null:
		sword_ability_collision_shape.radius = base_radius * radius_additional_perc
	else:
		push_error("Oops! Can't reach Sword ability collision shape!")

	var foreground_layer: Node2D = GameUtils.get_foreground() as Node2D
	if foreground_layer == null: return

	foreground_layer.add_child(sword_instance)

	sword_instance.hitbox_component.damage_amount = base_damage * dmg_additional_perc # In course damage_amount is 'damage'
	sword_instance.global_position = enemies[0].global_position
	sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4

	var enemy_direction: Vector2 = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = enemy_direction.angle()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	match upgrade.id:
		rate_upgrade : apply_rate_upgrade(current_upgrades)
		damage_upgrade : apply_damage_upgrade(current_upgrades)
		area_upgrade : apply_area_upgrade(current_upgrades)
		_: return


func apply_rate_upgrade(_current_upgrades:Dictionary) -> void:
	var upgrades_count: int = _current_upgrades[rate_upgrade]["quantity"]
	var percent_reduction: float = upgrades_count * rate_additional_perc
	sword_ability_timer.wait_time = base_wait_time * (1 - percent_reduction)
	sword_ability_timer.start()
	print(
		"⚔️ Sword rate reduction multiplier: %.2f for %d upgrdaes | New Sword rate is %.2f per sec"
		% [percent_reduction, upgrades_count, sword_ability_timer.wait_time]
		)


func apply_damage_upgrade(_current_upgrades:Dictionary) -> void:
	var upgrades_count: int = _current_upgrades[damage_upgrade]["quantity"]
	var damage_gain: float = upgrades_count * damage_gain_perc
	dmg_additional_perc += damage_gain
	print(
		"⚔️ Sword damage multiplier: %.2f for %d upgrdaes | New Sword damage is %.2f "
		% [dmg_additional_perc, upgrades_count, base_damage * dmg_additional_perc]
		)


func apply_area_upgrade(_current_upgrades:Dictionary) -> void:
	var upgrades_count: int = _current_upgrades[area_upgrade]["quantity"]
	var radius_multiplier: float = pow(1.0 + radius_gain_perc, upgrades_count)
	var radius_gain: float = sqrt(radius_multiplier)
	radius_additional_perc = radius_gain
	print(
		"⚔️ Sword radius multiplier: %.2f for %d upgrades | New sword radius is %.2f px"
		% [radius_additional_perc, upgrades_count, base_radius * radius_additional_perc]
	)
