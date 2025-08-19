extends Node

@export var axe_ability_scene: PackedScene

@onready var axe_ability_timer: Timer = $%Timer

var axe_damage: float = 10.0

func _ready() -> void:
	axe_ability_timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return

	var foreground: Node2D = get_tree().get_first_node_in_group("foreground_layer") as Node2D
	if foreground == null: return

	var axe_ability_instance: Node2D = axe_ability_scene.instantiate() as Node2D
	foreground.add_child(axe_ability_instance)
	axe_ability_instance.global_position = player.global_position
	axe_ability_instance.hitbox_component.damage_amount = axe_damage
