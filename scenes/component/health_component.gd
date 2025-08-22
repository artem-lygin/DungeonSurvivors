@icon("res://assets/godot/icons/Icon_HealthComponent.svg")
extends Node
class_name HealthComponent

signal died # emit from "check_death"
signal health_changed # emith from "damage"

@export var max_health: float = 10

var current_health: float

func _ready() -> void:
	current_health = max_health

func damage(damage_amount: float) -> void:
	current_health = max(current_health - damage_amount, 0)
	health_changed.emit()
	# TODO: Get Callable described
	Callable(check_death).call_deferred()


func get_health_percent() -> float:
	if max_health <= 0: return 0
	return min(current_health / max_health, 1)


func check_death() -> void:
	if current_health == 0:
		# Wait for hit_flash_component
		await  get_tree().create_timer(0.1).timeout
		died.emit()
		owner.queue_free()
