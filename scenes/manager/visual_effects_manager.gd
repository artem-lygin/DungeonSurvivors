extends Node2D

@export var player_light_component: PackedScene
@export var exp_collected_vfx_component: PackedScene
@export var player_sprite: Sprite2D


func _ready() -> void:
	GameEvents.expirience_vial_collected.connect(_on_experience_vial_collected)
	# Add Light effect around player
	var player_light_effect_instance: Node2D = player_light_component.instantiate() as Node2D
	if player_light_effect_instance == null: return


	var player: Node2D = GameUtils.get_player() as Node2D
	if player == null: return

	# Add components to scene tree
	player.add_child.call_deferred(player_light_effect_instance)


func _on_experience_vial_collected(_number: float) -> void:
	var player: Node2D = GameUtils.get_player() as Node2D
	if player == null: return

	# Add Exp collected effect
	var exp_collected_vfx_instance: Node2D = exp_collected_vfx_component.instantiate() as Node2D
	if exp_collected_vfx_instance == null: return

	player.add_child(exp_collected_vfx_instance)
