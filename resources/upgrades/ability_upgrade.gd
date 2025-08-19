extends Resource
class_name AbilityUpgrade

enum ItemRarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
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
@export var max_quantity: int
@export var type: ItemType
#@export var weight_rate: int = 1 # Going to be depricated
@export var weight_override: int = 0 # Manually set weight for WeightTable, ignored if 0
@export var dependency: AbilityUpgrade = null


func get_effective_weight(base_by_rarity: Dictionary) -> int:
	if weight_override > 0:
		return weight_override
	return int(base_by_rarity.get(rarity, 1))


func rarity_to_string() -> String:
	return ItemRarity.keys()[rarity]
