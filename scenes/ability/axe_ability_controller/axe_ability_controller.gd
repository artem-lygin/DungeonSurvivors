extends Node

@export var axe_ability_scene: PackedScene

@export_group("Axe Damage")
@export_range (1.0, 100.0) var base_damage: float = 10
@export var damage_gain_perc: float = .15 # 10 cumulative upgrades result 40 dmg

@export_group("Axe Spawn Rate")
@export var base_wait_time: float = 3.5
@export_range (0.0, 1.0) var rate_additional_perc: float = .1 # 10 cumulative upgrades result 1.2 cooldown

@export_group("Axe Area")
@export_range (0.0, 100.0) var base_radius: float = 10.0
@export_range (0.0, 1.0) var radius_gain_perc: float = .15 # 10 cumulative upgrades result 20px radius

@export_group("Upgrades IDs")
@export var rate_upgrade: String = "axe_rate"
@export var damage_upgrade: String = "axe_damage"
@export var area_upgrade: String = "axe_area"

@onready var axe_ability_timer: Timer = $%AxeAbilityTimer
@onready var axe_ability_collision_shape_node: CollisionShape2D
@onready var axe_ability_collision_shape: CircleShape2D

var dmg_additional_perc: float = 1
var wait_time_reduction: float = .1
var radius_additional_perc: float = 1

func _ready() -> void:
	axe_ability_timer.timeout.connect(_on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func _on_timer_timeout() -> void:
	var player: Node2D = GameUtils.get_player() as Node2D
	if player == null:
		return

	var foreground: Node2D = GameUtils.get_foreground() as Node2D
	if foreground == null:
		return

	var axe_ability_instance: Node2D = axe_ability_scene.instantiate() as Node2D

	axe_ability_collision_shape_node = axe_ability_instance.get_node("HitboxComponent/CollisionShape2D")
	axe_ability_collision_shape = axe_ability_collision_shape_node.shape as CircleShape2D
	if axe_ability_collision_shape != null:
		axe_ability_collision_shape.radius = base_radius * radius_additional_perc
	else:
		push_error("Oops! Can't reach Axe ability collision shape!")

	foreground.add_child(axe_ability_instance)
	axe_ability_instance.global_position = player.global_position
	axe_ability_instance.hitbox_component.damage_amount = base_damage * dmg_additional_perc

	axe_ability_timer.wait_time = base_wait_time
	axe_ability_timer.start()


func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	match upgrade.id:
		rate_upgrade : apply_rate_upgrade(current_upgrades)
		damage_upgrade : apply_damage_upgrade(current_upgrades)
		area_upgrade : apply_area_upgrade(current_upgrades)
		_: return

# TODO Recalculte axe rate applience to be cumulative (current_rate * decrease_pecent)
func apply_rate_upgrade(_current_upgrades:Dictionary) -> void:
	var upgrades_count: int = _current_upgrades[rate_upgrade]["quantity"]
	var percent_reduction: float = upgrades_count * rate_additional_perc
	axe_ability_timer.wait_time = base_wait_time - (base_wait_time * percent_reduction)
	axe_ability_timer.start()
	print(
		"🪓 Axe rate reduction multiplier: %.2f for %d upgrdaes | New axe cooldown is %.2f"
		% [percent_reduction, upgrades_count, axe_ability_timer.wait_time]
		)

# TODO Recalculte axe damage applience to be cumulative (current_damage * increase_pecent)
func apply_damage_upgrade(_current_upgrades:Dictionary) -> void:
	var upgrades_count: int = _current_upgrades[damage_upgrade]["quantity"]
	var damage_gain: float = upgrades_count * damage_gain_perc
	dmg_additional_perc += damage_gain
	print(
		"🪓 Axe damage multiplier: %.2f for %d upgrdaes | New axe damage is %.2f "
		% [dmg_additional_perc, upgrades_count, base_damage * dmg_additional_perc]
		)

# TODO Recalculte axe area applience to be cumulative (current_area * increase_pecent)
func apply_area_upgrade(_current_upgrades:Dictionary) -> void:
	var upgrades_count: int = _current_upgrades[area_upgrade]["quantity"]
	var radius_multiplier: float = pow(1.0 + radius_gain_perc, upgrades_count)
	var radius_gain: float = sqrt(radius_multiplier)
	radius_additional_perc = radius_gain
	print(
		"🪓 Axe hitbox radius multiplier: %.2f for %d upgrades | New axe hitbox radius is %.2f px"
		% [radius_additional_perc, upgrades_count, base_radius * radius_additional_perc]
	)
