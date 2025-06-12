extends Node

signal expiriance_vial_collected(number: float)


func emit_experiance_vial_collected(number: float):
	expiriance_vial_collected.emit(number)
