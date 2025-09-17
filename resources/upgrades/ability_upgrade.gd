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

const TAGS_FOLDER = "res://resources/theme/rarity_labels/"
const CARDS_FOLDER = "res://resources/theme/upgrade_cards_styleboxes/"

const TAG_COMMON = preload(TAGS_FOLDER+"stylebox_common.tres")
const TAG_UNCOMMON = preload(TAGS_FOLDER+"stylebox_uncommon.tres")
const TAG_RARE = preload(TAGS_FOLDER+"stylebox_rare.tres")
const TAG_MYTHICAL = preload(TAGS_FOLDER+"stylebox_mythical.tres")
const TAG_LEGENDARY = preload(TAGS_FOLDER+"stylebox_legendary.tres")

const CARD_COMMON = preload(CARDS_FOLDER+"upgrade_card_common.tres")
const CARD_UNCOMMON = preload(CARDS_FOLDER+"upgrade_card_uncommon.tres")
const CARD_RARE = preload(CARDS_FOLDER+"upgrade_card_rare.tres")
const CARD_MYTHICAL = preload(CARDS_FOLDER+"upgrade_card_mythical.tres")
const CARD_LEGENDARY = preload(CARDS_FOLDER+"upgrade_card_common.tres")

const EFFECT_MYTHICAL = preload("res://resources/materials/card_mythical_effect.tres")


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
		ItemRarity.MYTHICAL :	return Color(0.835, 0.133, 0.812)
		ItemRarity.LEGENDARY :	return Color(0.910, 0.788, 0.533)
		ItemRarity.HOLY:		return Color.WHITE
		ItemRarity.CURSED:		return Color.WHITE
		_:						return Color.WHITE


func get_tag_stylebox() -> Resource:
	match self.rarity:
		ItemRarity.COMMON: 		return TAG_COMMON
		ItemRarity.UNCOMMON: 	return TAG_UNCOMMON
		ItemRarity.RARE: 		return TAG_RARE
		ItemRarity.MYTHICAL: 	return TAG_MYTHICAL
		ItemRarity.LEGENDARY: 	return TAG_LEGENDARY
		ItemRarity.HOLY: 		return TAG_COMMON
		ItemRarity.CURSED: 		return TAG_COMMON
		_: 						return TAG_COMMON


func get_card_stylebox() -> Resource:
	match self.rarity:
		ItemRarity.COMMON: 		return CARD_COMMON
		ItemRarity.UNCOMMON: 	return CARD_UNCOMMON
		ItemRarity.RARE: 		return CARD_RARE
		ItemRarity.MYTHICAL: 	return CARD_MYTHICAL
		ItemRarity.LEGENDARY: 	return CARD_LEGENDARY
		ItemRarity.HOLY: 		return CARD_COMMON
		ItemRarity.CURSED: 		return CARD_COMMON
		_: 						return CARD_COMMON


func get_rarity_effect() -> Resource:
	match self.rarity:
		ItemRarity.MYTHICAL: 	return EFFECT_MYTHICAL
		ItemRarity.LEGENDARY: 	return EFFECT_MYTHICAL
		ItemRarity.HOLY: 		return EFFECT_MYTHICAL
		ItemRarity.CURSED: 		return EFFECT_MYTHICAL
		_: 						return null
