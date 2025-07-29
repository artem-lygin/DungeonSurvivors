extends Node2D

const AXE_MAX_RADIUS = 100

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var axe_base_rotation: Vector2 = Vector2.RIGHT


func _ready() -> void:
	axe_base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	tween.tween_method(_axe_tween_method, 0.0, 2.0, 3)
	tween.tween_callback(queue_free)
	
	
func _axe_tween_method(axe_rotations: float) -> void:
	var percent: float = (axe_rotations / 2)
	var axe_current_radius: float = percent * AXE_MAX_RADIUS
	# var axe_current_direction: Vector2 = Vector2.RIGHT.rotated(axe_rotations * TAU)
	var axe_current_direction: Vector2 = axe_base_rotation.rotated(axe_rotations * TAU)
	
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:return
	
	global_position = player.global_position + (axe_current_direction * axe_current_radius)
