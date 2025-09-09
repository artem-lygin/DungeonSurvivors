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


func _ready() -> void:
	GameEvents.expirience_vial_collected.connect(on_experience_collected)
	load_save_file()

func load_save_file() -> void:
	if !FileAccess.file_exists(SAVE_PATH_FILE):
		return
	var save_file: FileAccess = FileAccess.open(SAVE_PATH_FILE, FileAccess.READ)
	save_data = save_file.get_var()
	print(save_data)


func save_to_file() -> void:
	var save_file: FileAccess = FileAccess.open(SAVE_PATH_FILE, FileAccess.WRITE)
	save_file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade) -> void:
	if !save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}

	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1


func on_experience_collected(number:float) -> void:
	save_data["meta_upgrade_currency"] += number
