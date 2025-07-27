extends CharacterBody2D

const MAX_SPEED = 120
const ACCELERATION_SMOOTHING: int = 25
const ISO_RATIO: float = .5

func _process(delta: float) -> void:
	var movement_vector: Vector2 = get_movement_vector()
	var direction: Vector2 = movement_vector.normalized()
	var target_velocity: Vector2 = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()

func get_movement_vector() -> Vector2:
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement * ISO_RATIO)
