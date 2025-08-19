extends Node2D

@onready var exp_collect_effect: CPUParticles2D = %ExpCollectEffect

var player: Node2D
var player_sprite: Sprite2D

func _ready() -> void:
	player = GameUtils.get_player()

	exp_collect_effect.finished.connect(_on_effect_finished)
	exp_collect_effect.emitting = true


func _on_effect_finished() -> void:
	queue_free()
