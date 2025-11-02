@abstract
class_name Enemy extends CharacterBody2D

@export var max_health: int = 10
@export var base_weight: int = 10
@export var base_speed: int = 40
@export var base_acceleration: float = 10.0

@onready var health_component: HealthComponent
@onready var velocity_component: VelocityComponent
@onready var hurtbox_component: HurboxComponent
@onready var hit_audio_component: HitAudioComponent

var debug_draw: bool = ProjectSettings.get_setting("game/debug/player/debug_draw")
