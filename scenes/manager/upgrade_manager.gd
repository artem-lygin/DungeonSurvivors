extends Node

#@export var upgrade_pool_array: Array[AbilityUpgrade] # Going to be depricated
@export var upgrade_pool_dict: Dictionary [String, AbilityUpgrade] = {}
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene
@export var rarity_config: RarityConfig

@onready var base_by_rarity: Dictionary = rarity_config.to_dict()

var upgrades_available: int = 3 # Count of overall available upgrades for each levelup

var dependecies_upgrades: Dictionary = {} # Store Upgrades other upgrades depends on
var current_upgrades: Dictionary = {}

var upgrade_pool: WeightedTable = WeightedTable.new()

func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)

	# Adding to Upgrade Pool all upgrades but Axe Damage upgrade
	for item_key: String in upgrade_pool_dict:
		if can_be_obtained(upgrade_pool_dict[item_key]):
			add_to_weighttable(upgrade_pool_dict[item_key])


func is_upgrade_owned(upgrade: AbilityUpgrade) -> bool:
	return current_upgrades.has(upgrade.id)


func can_be_obtained(upgrade: AbilityUpgrade) -> bool:
	return upgrade.dependency == null or is_upgrade_owned(upgrade.dependency)


func add_to_weighttable(upgrade: AbilityUpgrade) -> void:
	if rarity_config == null:
		push_error("RarityConfig not assigned to UpgradeManager!")
		return

	var weight := upgrade.get_effective_weight(base_by_rarity)
	upgrade_pool.add_item(upgrade, weight)


# Adding dependent upgrades from pool to weightTable
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade) -> void:
	for candidate: AbilityUpgrade in upgrade_pool_dict.values():
		if candidate == null:
			continue

		var dependency: AbilityUpgrade = candidate.dependency
		# Is candidate depends on chosen_upgrade?
		if dependency != null and dependency == chosen_upgrade:
			if not current_upgrades.has(candidate.id):
				add_to_weighttable(candidate)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade: bool = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resourse": upgrade,
			"quantity": 1
		}
	else :
		current_upgrades[upgrade.id]["quantity"] += 1

	# Checking if Upgrade reached max quantity, if true: remove from upgrade_pool
	if upgrade.max_quantity > 0:
		var current_quantity: int = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			#upgrade_pool = upgrade_pool.remove_item(upgrade)
			upgrade_pool.remove_item(upgrade)

	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	# print(current_upgrades)


# Pick upgrades from pool to show after levelup
func pick_upgrades() -> Array:
	var chosen_upgrades: Array[AbilityUpgrade] = []

	for count in upgrades_available:
		if upgrade_pool.items.size() == chosen_upgrades.size(): break

		var chosen_upgrade: AbilityUpgrade = upgrade_pool.pick_item(chosen_upgrades) as AbilityUpgrade
		if chosen_upgrade == null: break
		chosen_upgrades.append(chosen_upgrade)

	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)


func on_level_up(_current_level: int) -> void:

	var upgrade_screen_instance: Node = upgrade_screen_scene.instantiate()
	var ui_layer: Node = GameUtils.get_ui()
	ui_layer.add_child(upgrade_screen_instance)

	var chosen_upgrades: Array = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
