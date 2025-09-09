extends Resource
class_name RarityConfig

@export_group("Base weights per rarity")
@export var common_weight: int = 50
@export var uncommon_weight: int = 40
@export var rare_weight: int = 30
@export var mythical_weight: int = 20
@export var legendary_weight: int = 10
@export var holy_weight: int = 1
@export var cursed_weight: int = 1

func to_dict() -> Dictionary:
	# Uses AbilityUpgrade.ItemRarity enum as keys
	return {
		AbilityUpgrade.ItemRarity.COMMON: max(common_weight, 0),
		AbilityUpgrade.ItemRarity.UNCOMMON: max(uncommon_weight, 0),
		AbilityUpgrade.ItemRarity.RARE: max(rare_weight, 0),
		AbilityUpgrade.ItemRarity.MYTHICAL: max(mythical_weight, 0),
		AbilityUpgrade.ItemRarity.LEGENDARY: max(legendary_weight, 0),
		AbilityUpgrade.ItemRarity.HOLY: max(holy_weight, 0),
		AbilityUpgrade.ItemRarity.CURSED: max(cursed_weight, 0),
	}
