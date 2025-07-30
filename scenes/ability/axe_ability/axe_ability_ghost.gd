extends Node2D

@onready var ghost_timer: Timer = $Timer

func _ready() -> void:
	ghost_timer.timeout.connect(_on_timer_timeout)
	
	
func _on_timer_timeout() -> void:
	queue_free()
