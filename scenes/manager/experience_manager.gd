extends Node

signal experience_updated(current_experiance: float, target_experiance: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 5

var current_experience: int = 0
var current_level: int = 1
var target_experience: int = 5

func _ready() -> void:
	GameEvents.expirience_vial_collected.connect(on_experience_vial_collected)

func on_experience_vial_collected(number: float) -> void:
	increment_experience(number)

func increment_experience(number: float) -> void:
	current_experience = min(current_experience+number, target_experience)
	# print(current_experience)
	experience_updated.emit(current_experience, target_experience)

	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		experience_updated.emit(current_experience, target_experience)

		level_up.emit(current_level)
