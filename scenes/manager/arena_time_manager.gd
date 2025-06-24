extends Node

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL = 5

@export var round_end_screen_scene: PackedScene

@onready var arena_timer: Timer = $%ArenaTimer

var arena_difficulty: int = 0

func _ready() -> void:
	arena_timer.timeout.connect(on_arena_timer_timeout)


func _process(delta: float) -> void:
	# Managing arena difficulty
	var next_time_target: float = arena_timer.wait_time - ((arena_difficulty+1) * DIFFICULTY_INTERVAL)
	if arena_timer.time_left <= next_time_target:
		arena_difficulty += 1
		arena_difficulty_increased.emit(arena_difficulty)
		print("😓 Arena Difficulty is ", arena_difficulty)


func get_time_elapsed():
	# return arena_timer.wait_time - arena_timer.time_left # This used in the course
	return arena_timer.time_left # Returns countdown instead of countup


func on_arena_timer_timeout():
	var round_end_screen_instance: Node = round_end_screen_scene.instantiate()
	add_child(round_end_screen_instance)
