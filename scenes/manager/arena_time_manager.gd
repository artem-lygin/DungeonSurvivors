extends Node

@export var victory_screen_scene: PackedScene

@onready var arena_timer: Timer = $%ArenaTimer


func _ready() -> void:
	arena_timer.timeout.connect(on_arena_timer_timeout)


func get_time_elapsed():
	return arena_timer.wait_time - arena_timer.time_left


func on_arena_timer_timeout():
	var victory_screen_instance: Node = victory_screen_scene.instantiate()
	add_child(victory_screen_instance)
