extends Resource
class_name RarityConfig

@export_group("Base weights per rarity")
@export var common_weight: int = 50
@export var uncommon_weight: int = 40
@export var rare_weight: int = 30
@export var epic_weight: int = 20
@export var legendary_weight: int = 10

func to_dict() -> Dictionary:
	# Uses AbilityUpgrade.ItemRarity enum as keys
	return {
		AbilityUpgrade.ItemRarity.COMMON: max(common_weight, 0),
		AbilityUpgrade.ItemRarity.UNCOMMON: max(uncommon_weight, 0),
		AbilityUpgrade.ItemRarity.RARE: max(rare_weight, 0),
		AbilityUpgrade.ItemRarity.EPIC: max(epic_weight, 0),
		AbilityUpgrade.ItemRarity.LEGENDARY: max(legendary_weight, 0),
	}
