extends Node

signal expirience_vial_collected(number: float)


func emit_experience_vial_collected(number: float):
	expirience_vial_collected.emit(number)
