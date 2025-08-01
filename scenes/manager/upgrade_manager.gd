extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades: Dictionary = {
	#to be filled with apply_upgrade method below
}


func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade) -> void:
	var has_upgrade: bool = current_upgrades.has(upgrade.upgrade_id)
	if !has_upgrade:
		current_upgrades[upgrade.upgrade_id] = { #"updrade_id" named as "id" in course
			"resourse": upgrade,
			"quantity": 1
		}
	else :
		current_upgrades[upgrade.upgrade_id]["quantity"] += 1 #"updrade_id" named as "id" in course
		
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
	# print(current_upgrades)	


func pick_upgrades() -> Array:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades: Array = upgrade_pool.duplicate()
	
	for i in 2: # count depends of upgrades pool size
		var chosen_upgrade: AbilityUpgrade = filtered_upgrades.pick_random() as AbilityUpgrade
		chosen_upgrades.append(chosen_upgrade)
		# filter returns every upgrade to filtered_upgrades that does not share upgrade_id of chosen_upgrade
		filtered_upgrades = filtered_upgrades.filter(
			func (upgrade: AbilityUpgrade) -> bool: 
				return upgrade.upgrade_id != chosen_upgrade.upgrade_id # "updrade_id" named as "id" in course
		) 
		
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	apply_upgrade(upgrade)


func on_level_up(_current_level: int) -> void:
	var upgrade_screen_instance: Node = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades: Array = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
