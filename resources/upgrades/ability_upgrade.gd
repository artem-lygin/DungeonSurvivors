extends Resource
class_name AbilityUpgrade

enum ItemRarity {
	COMMON,
	UNCOMMON,
	RARE,
	MYTHICAL,
	LEGENDARY,
	HOLY,
	CURSED
	}

enum ItemType {
	UPGRADE,
	ABILITY,
	WONDER
}

@export_category("Basic info")
@export var id: String
@export var name: String
@export var rarity: ItemRarity
@export_multiline var description: String
@export_category("Stats and parameters")
@export var max_quantity: int = 1
@export var type: ItemType
#@export var weight_rate: int = 1 # Going to be depricated
@export var weight_override: int = 0 # Manually set weight for WeightTable, ignored if 0
@export var dependency: AbilityUpgrade = null

const STYLEBOX_COMMON = preload("res://resources/theme/rarity_labels/stylebox_common.tres")
const STYLEBOX_LEGENDARY = preload("res://resources/theme/rarity_labels/stylebox_legendary.tres")
const STYLEBOX_MYTHICAL = preload("res://resources/theme/rarity_labels/stylebox_mythical.tres")
const STYLEBOX_RARE = preload("res://resources/theme/rarity_labels/stylebox_rare.tres")
const STYLEBOX_UNCOMMON = preload("res://resources/theme/rarity_labels/stylebox_uncommon.tres")


func get_effective_weight(base_by_rarity: Dictionary) -> int:
	if weight_override > 0:
		return weight_override
	return int(base_by_rarity.get(rarity, 1))


func rarity_to_string() -> String:
	return ItemRarity.keys()[rarity]


func get_rarity_color() -> Color:
	match self.rarity:
		ItemRarity.COMMON:		return Color(0.486, 0.518, 0.592)
		ItemRarity.UNCOMMON :	return Color(0.361, 0.475, 0.651)
		ItemRarity.RARE :		return Color(0.294, 0.631, 1.000)
		ItemRarity.MYTHICAL :		return Color(0.835, 0.133, 0.812)
		ItemRarity.LEGENDARY :	return Color(0.910, 0.788, 0.533)
		ItemRarity.HOLY:		return Color.WHITE
		ItemRarity.CURSED:		return Color.WHITE
		_:						return Color.WHITE


func get_rarity_stylebox() -> Resource:
	match self.rarity:
		ItemRarity.COMMON: return STYLEBOX_COMMON
		ItemRarity.UNCOMMON: return STYLEBOX_UNCOMMON
		ItemRarity.RARE: return STYLEBOX_RARE
		ItemRarity.MYTHICAL: return STYLEBOX_MYTHICAL
		ItemRarity.LEGENDARY: return STYLEBOX_LEGENDARY
		ItemRarity.HOLY: return STYLEBOX_COMMON
		ItemRarity.CURSED: return STYLEBOX_COMMON
		_: return STYLEBOX_COMMON
