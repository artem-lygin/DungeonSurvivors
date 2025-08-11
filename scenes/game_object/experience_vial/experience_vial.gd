extends Node2D

@onready var pickup_area: Area2D = $%Area2D
@onready var pickup_collision: CollisionShape2D = $%CollisionShape2D
@onready var sprite: Sprite2D = %Sprite2D

var pickaup_tween_duration: float = 0.6

func _ready() -> void:
	pickup_area.area_entered.connect(_on_area_entered)


func _tween_collect(percent: float, start_position: Vector2) -> void:
	var player: Node2D = GameUtils.get_player() as Node2D
	if player == null: return

	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start: Vector2 = player.global_position - start_position
	var target_rotation: float = direction_from_start.angle() + rad_to_deg(90)
	rotation = lerp_angle(rotation, target_rotation, 1 - exp(-2 * get_process_delta_time()))

func _collect() -> void:
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func _disable_collision() -> void:
	pickup_collision.disabled = true


func _on_area_entered(_other_area: Area2D) -> void:
	Callable(_disable_collision).call_deferred()

	var tween: Tween = create_tween()
	tween.set_parallel() # run tweens in paralel

	tween.tween_method(_tween_collect.bind(global_position), 0.0, 1.0, pickaup_tween_duration)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK) # Exacuting EaseInBack transition via tween

	tween.tween_property(sprite, "scale", Vector2.ZERO, .05).set_delay(pickaup_tween_duration - .05)

	tween.chain() # waiting to finish all tweens in chain
	tween.tween_callback(_collect)
