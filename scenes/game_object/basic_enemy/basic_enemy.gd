extends Enemy

#@export var max_health: int = 10
#@export var weight: int = 10
# ---- COMPONENTS ----
#@onready var health_component: HealthComponent = $%HealthComponent
#@onready var velocity_component: VelocityComponent = $%VelocityComponent
#@onready var hurtbox_component: HurboxComponent = $%HurtboxComponent
#@onready var hit_audio_component: HitAudioComponent = $%HitAudioComponent
# ---- OTHER NODES ----
@onready var visuals: Node2D = $%Visuals
@onready var occluder_node: LightOccluder2D = $%LightOccluder2D


func _ready() -> void:
	set_components()

	if occluder_node != null:
		occluder_node.occluder = occluder_node.occluder.duplicate()


func set_components() -> void:
	health_component = $%HealthComponent
	velocity_component= $%VelocityComponent
	hurtbox_component = $%HurtboxComponent
	hit_audio_component = $%HitAudioComponent
	health_component.current_health = max_health
	velocity_component.max_speed = base_speed
	velocity_component.acceleration = base_acceleration


func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

	# Facing Sprite2D in movement direction and swapping occluder's cull_mode
	var move_sign: Variant = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign, 1)
		if occluder_node != null:
			match move_sign:
				-1.0 :	occluder_node.occluder.cull_mode = OccluderPolygon2D.CULL_CLOCKWISE
				1.0 :	occluder_node.occluder.cull_mode = OccluderPolygon2D.CULL_COUNTER_CLOCKWISE

	# DebugMode check and redraw
	if debug_draw:
		queue_redraw()


# Debug tools to Velocity Component and apply real direction and velocity to be drawn
func _draw() -> void:
	if not debug_draw: return

	var player: Node2D = GameUtils.get_player() as Node2D
	var direction_to_player: Vector2 = (player.global_position - self.global_position).normalized()
	draw_line(Vector2.ZERO, direction_to_player * velocity_component.max_speed, Color(1, 0.25, 0, 0.4), 1) # AIM of movement
	draw_line(Vector2.ZERO, velocity, Color.ORANGE_RED, 1) # Movement
