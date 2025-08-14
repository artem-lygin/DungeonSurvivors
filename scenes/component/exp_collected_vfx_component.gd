extends Node2D

@onready var exp_collect_effect: CPUParticles2D = %ExpCollectEffect

func _ready() -> void:
	exp_collect_effect.finished.connect(_on_effect_finished)
	exp_collect_effect.emitting = true


func _on_effect_finished() -> void:
	queue_free()
