@icon("res://assets/godot/icons/Icon_HurtboxComponent.svg")
extends Area2D
class_name HurboxComponent

signal hit

@export var health_component: HealthComponent

var floating_text_scene: PackedScene = preload("res://scenes/ui/floating_text.tscn")


func _ready() -> void:
	area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D) -> void:
	if not other_area is HitboxComponent: return
	if health_component == null: return

	var hitbox_component: HitboxComponent = other_area as HitboxComponent

	health_component.damage(hitbox_component.damage_amount)

	var floating_text: Node2D = floating_text_scene.instantiate() as Node2D
	GameUtils.get_ui().add_child(floating_text)

	floating_text.global_position = global_position + (Vector2.UP * 16)
	floating_text.start(str(hitbox_component.damage_amount).pad_decimals(0))

	hit.emit()
