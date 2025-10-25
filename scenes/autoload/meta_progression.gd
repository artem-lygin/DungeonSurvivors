extends Node

signal meta_currency_updated

const SAVE_PATH_FILE = Paths.SAVE_PATH_FILE

var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {
		#"meta_upgrade_id": {
			#"quantity": 1,
			#"total_cost": 123,
		#}
	}
}

var is_override_debug_mode: bool = ProjectSettings.get_setting("game/debug/meta_progress/override_meta_currency_balance")
var debug_log: bool = ProjectSettings.get_setting("game/debug/meta_progress/debug_log")
var is_fresh_start: bool = ProjectSettings.get_setting("game/debug/meta_progress/fresh_start")


func _ready() -> void:
	GameEvents.expirience_vial_collected.connect(on_experience_collected)
	load_save_file()

	if is_fresh_start:
		reset_meta_upgrades()
		MetaProgression.set_meta_currency(0)


func set_meta_currency(amount: int) -> void:
	if is_override_debug_mode:
		ProjectSettings.set_setting("game/debug/meta_progress/meta_currency_balance", amount)
	else:
		save_data.meta_upgrade_currency = max(amount, 0)

	if debug_log: print("Current balance: ", get_meta_currency())

	meta_currency_updated.emit(get_meta_currency())



func get_meta_currency() -> int:
	var meta_currency_balance: int = save_data.meta_upgrade_currency

	if is_override_debug_mode:
		meta_currency_balance = ProjectSettings.get_setting("game/debug/meta_progress/meta_currency_balance")

	return meta_currency_balance


func get_meta_upgrades_owned() -> Dictionary:
	if !FileAccess.file_exists(SAVE_PATH_FILE):
		return {}
	if not save_data.has("meta_upgrades"):
		return {}
	var meta_upgrades_owned: Dictionary = save_data.get("meta_upgrades", {})
	return meta_upgrades_owned


func get_meta_upgrade_owned_amount(meta_upgrade: MetaUpgrade) -> int:
	if !FileAccess.file_exists(SAVE_PATH_FILE):
		return 0
	if not save_data.has("meta_upgrades"):
		return 0
	var owned_amount: int = save_data.get("meta_upgrades", {}).get(meta_upgrade.id, {}).get("quantity", 0)
	return owned_amount


func get_meta_upgrade_total_cost(meta_upgrade: MetaUpgrade) -> int:
	if !FileAccess.file_exists(SAVE_PATH_FILE):
		return 0
	if not save_data.has("meta_upgrades"):
		return 0
	var total_cost: int = save_data.get("meta_upgrades", {}).get(meta_upgrade.id, {}).get("total_cost", 0)
	return total_cost


## Adds meta_upgrade (arg) to save_data, adding ir's price to "total_cost" of meta upgrades
## Decreasing amount of meta currency on upgrade price amount
## Saves the data
func add_meta_upgrade(meta_upgrade: MetaUpgrade) -> void:
	if !save_data["meta_upgrades"].has(meta_upgrade.id):
		save_data["meta_upgrades"][meta_upgrade.id] = {
			"quantity": 0,
			"total_cost": 0
		}

	save_data["meta_upgrades"][meta_upgrade.id]["quantity"] += 1
	save_data["meta_upgrades"][meta_upgrade.id]["total_cost"] += meta_upgrade.resource_cost

	var meta_currency_amount: int = get_meta_currency() - meta_upgrade.resource_cost
	set_meta_currency(meta_currency_amount)
	if debug_log: print(save_data)
	save_to_file()


func reset_meta_upgrades() -> void:
	save_data["meta_upgrades"] = {}
	if debug_log: print(save_data)
	save_to_file()


func on_experience_collected(number:float) -> void:
	save_data["meta_upgrade_currency"] += number


func load_save_file() -> void:
	if !FileAccess.file_exists(SAVE_PATH_FILE):
		return
	var save_file: FileAccess = FileAccess.open(SAVE_PATH_FILE, FileAccess.READ)
	save_data = save_file.get_var()
	if debug_log: print(save_data)


func save_to_file() -> void:
	var save_file: FileAccess = FileAccess.open(SAVE_PATH_FILE, FileAccess.WRITE)
	save_file.store_var(save_data)
