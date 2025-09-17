extends Node

const SAVE_PATH_FILE = "user://game.save"

var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {
		#"experience_gain": {
			#"quantity": 1,
		#}
	}
}

var is_override_debug_mode: bool = ProjectSettings.get_setting("game/debug/meta_progress/override_meta_currency_balance")

func _ready() -> void:
	GameEvents.expirience_vial_collected.connect(on_experience_collected)
	load_save_file()


func set_meta_currency(amount: int) -> void:
	if is_override_debug_mode:
		ProjectSettings.set_setting("game/debug/meta_progress/meta_currency_balance", amount)
	else:
		save_data.meta_upgrade_currency = max(amount, 0)

func get_meta_currency() -> int:
	var meta_currency_balance: int = save_data.meta_upgrade_currency

	if is_override_debug_mode:
		meta_currency_balance = ProjectSettings.get_setting("game/debug/meta_progress/meta_currency_balance")

	return meta_currency_balance


func load_save_file() -> void:
	if !FileAccess.file_exists(SAVE_PATH_FILE):
		return
	var save_file: FileAccess = FileAccess.open(SAVE_PATH_FILE, FileAccess.READ)
	save_data = save_file.get_var()
	print(save_data)


func save_to_file() -> void:
	var save_file: FileAccess = FileAccess.open(SAVE_PATH_FILE, FileAccess.WRITE)
	save_file.store_var(save_data)


func add_meta_upgrade(meta_upgrade: MetaUpgrade) -> void:
	if !save_data["meta_upgrades"].has(meta_upgrade.id):
		save_data["meta_upgrades"][meta_upgrade.id] = {
			"quantity": 0
		}

	save_data["meta_upgrades"][meta_upgrade.id]["quantity"] += 1

	var meta_currency_amount: int = get_meta_currency() - meta_upgrade.resource_cost
	set_meta_currency(meta_currency_amount)
	print(save_data)
	save_to_file()


func on_experience_collected(number:float) -> void:
	save_data["meta_upgrade_currency"] += number
