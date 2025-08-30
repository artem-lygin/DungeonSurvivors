extends CharacterBody2D

# COMPONENTS -----------------------------------------------
@onready var health_component: Node = $%HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent

# NODES ----------------------------------------------------
@onready var damage_interval_timer: Timer = $%DamageIntervalTimer
@onready var enemies_collision_area: Area2D = $%EnemiesCollisionArea2D
@onready var health_bar: ProgressBar = $%HealthBar #progressbar
@onready var abilities: Node = $%Abilities
@onready var animation_player: AnimationPlayer = $%AnimationPlayer
@onready var visuals_node: Node2D = $Visuals
@onready var hit_stream_player: AudioStreamPlayer2D = $%HitAudioPlayer2D
@onready var walk_audio_stream_player_2d: AudioStreamPlayer2D = $%WalkAudioStreamPlayer2D


var number_colliding_bodies: int = 0
var base_speed: float
var step_timer: float = 0
var footstep_interval: float = .15

func _ready() -> void:
	base_speed = velocity_component.max_speed

	# player_base_color = player_light.color
	enemies_collision_area.body_entered.connect(on_body_entered)
	enemies_collision_area.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(_on_ability_upgrade_added) # Check if ability upgraded is "Ability" and instantiate

	update_health_display()


func _process(delta: float) -> void:
	if DebugUtils.debug_mode:
		queue_redraw()
	var movement_vector: Vector2 = get_movement_vector() # Raw vectors
	var direction: Vector2 = movement_vector.normalized() # Normalisation forces movement vectors be 1
	var iso_direction: Vector2 = IsoUtils.to_isometric_direction(direction) # simple transformation

	velocity_component.accelerate_in_direction(iso_direction)
	velocity_component.move(self)


	# Footsteps Sound
	if movement_vector != Vector2.ZERO:
		step_timer -= delta
		if step_timer <= 0.0:
			play_footstep()
			step_timer = footstep_interval
	else:
		step_timer = 0.0

	# Animation Sprite2D
	if movement_vector.x != 0 or movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")

	# Flipping the Sprite2D
	var move_sign: Variant = sign(movement_vector.x)
	if move_sign != 0:
		visuals_node.scale = Vector2(move_sign, 1)


func get_movement_vector() -> Vector2:
	var x_movement: float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement: float = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage() -> void:
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped(): return
	health_component.damage(1 * number_colliding_bodies)
	damage_interval_timer.start()
	print("❤️: ", health_component.current_health)


func update_health_display() -> void:
	health_bar.value = health_component.get_health_percent()


func on_body_entered(_other_body: Node2D) -> void:
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(_other_body: Node2D) -> void:
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout() -> void:
	check_deal_damage()


func on_health_changed() -> void:
	GameEvents.emit_player_damaged()
	hit_stream_player.play()
	update_health_display()

# If picked ability is "Ability" class then instantiate to a Abilities of the Player
func _on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary) -> void:
	if ability_upgrade is Ability:
		var ability: Ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * .1)


func play_footstep() -> void:
	walk_audio_stream_player_2d.pitch_scale = randf_range(0.95, 1.05)
	walk_audio_stream_player_2d.play()

func _draw() -> void:
	if DebugUtils.debug_mode:
		draw_line(Vector2.ZERO, velocity*1, Color.ORANGE, 1)
	else:
		return
