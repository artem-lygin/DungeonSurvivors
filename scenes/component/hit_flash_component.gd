extends Node

@export var health_component: Node
@export var sprite: Sprite2D

# TODO make autoloaded script for all preloaded paths
var hit_flash_material: Resource = preload("res://scenes/component/hit_flash_component_material.tres")
var hit_flash_tween: Tween
var hit_flash_tween_duration: float = 0.25


func _ready() -> void:
	health_component.health_changed.connect(_on_health_changed)
	sprite.material = hit_flash_material.duplicate()


func _on_health_changed() -> void:
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)

	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, hit_flash_tween_duration)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART) # Exacuting EaseInQuart transition via tween
