extends CharacterBody2D

const MAX_SPEED = 40 # Basic Enemy speed

@onready var health_component: HealthComponent = $HealthComponent
@onready var visuals_node: Node2D = $Visuals
@onready var occluder_node: LightOccluder2D = $%LightOccluder2D

func _ready() -> void:
	if occluder_node != null:
		occluder_node.occluder = occluder_node.occluder.duplicate()

func _process(_delta: float) -> void:
	
	if DebugUtils.debug_mode:
		queue_redraw()
	var direction: Vector2 = get_direction_to_player()
	# var iso_direction: Vector2 = IsoUtils.to_isometric(direction)
	velocity = direction * MAX_SPEED
	move_and_slide()
	
	var move_sign: Variant = sign(direction.x)
	if move_sign != 0:
		visuals_node.scale = Vector2(-move_sign, 1)
		if occluder_node != null:
			match move_sign:
				-1.0 :	occluder_node.occluder.cull_mode = OccluderPolygon2D.CULL_CLOCKWISE
				1.0 :	occluder_node.occluder.cull_mode = OccluderPolygon2D.CULL_COUNTER_CLOCKWISE


func get_direction_to_player() -> Vector2:
	# @warning_ignore("untyped_declaration")
	var player_node: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		var direction_to_player: Vector2 = (player_node.global_position - global_position).normalized()
		#var x_direction: float = direction_to_player.x
		#var y_direction: float = direction_to_player.y * 0.5
		#var iso_scale: float = sqrt(pow(x_direction, 2) + pow(y_direction, 2))
		return IsoUtils.to_isometric_length(direction_to_player)
	return Vector2.ZERO


func on_area_entered(_other_area: Area2D) -> void:
	health_component.damage(5)
	

func _draw() -> void:
	if DebugUtils.debug_mode:
		var player_node: Node2D = get_tree().get_first_node_in_group("player") as Node2D
		var direction_to_player: Vector2 = (player_node.global_position - global_position).normalized()
		draw_line(Vector2.ZERO, direction_to_player * MAX_SPEED, Color(1, 0.270588, 0, 0.4), 1) # AIM of movement
		draw_line(Vector2.ZERO, get_direction_to_player() * MAX_SPEED, Color.ORANGE_RED, 1) # Movement
	else:
		return
