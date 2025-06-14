extends Node

@export var upgrades_pool: Array[AbilityUpgrade]
@export var experience_manager: Node

var current_upgrades = {
}

func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)
	
	
func on_level_up(current_level: int):
	var chosen_upgrade = upgrades_pool.pick_random() as AbilityUpgrade
	if chosen_upgrade == null:
		return
		
	var has_upgrade = current_upgrades.has(chosen_upgrade.res_id)
	if !has_upgrade:
		current_upgrades[chosen_upgrade.res_id] = {
			"resourse": chosen_upgrade,
			"quantity": 1
		}
	else :
		current_upgrades[chosen_upgrade.res_id]["quantity"] += 1
		
	# print(current_upgrades)
	
	
