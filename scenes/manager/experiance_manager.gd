extends Node

var current_experiance = 0

func _ready():
	GameEvents.expiriance_vial_collected.connect(on_experiance_vial_collected)

func increment_experiance(number: float):
	current_experiance += number
	print(current_experiance)
	
	
func on_experiance_vial_collected(number: float):
	increment_experiance(number)
