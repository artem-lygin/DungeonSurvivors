extends Node

const SPAWN_RADIUS: int = 420
const DIFFICULTY_INCREASED_RATIO = 0.1

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var enemy_spawn_timer: Timer = $Timer

var enemy_spawn_time: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_spawn_time = enemy_spawn_timer.wait_time
	enemy_spawn_timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	
	
func on_timer_timeout() -> void:
	enemy_spawn_timer.start() # Handling staring the timer here to be able to change it wait_time
	
	@warning_ignore("untyped_declaration")
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return
		
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 =  player.global_position + (random_direction * SPAWN_RADIUS)
	
	# Instantiate basic enemy node into the scene
	var enemy: Node2D = basic_enemy_scene.instantiate() as Node2D
	@warning_ignore("untyped_declaration")
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null: return
	entities_layer.add_child(enemy) #add the scene as child node of "Main" node
	enemy.global_position = spawn_position
	
	
func on_arena_difficulty_increased(arena_difficulty: int) -> void:
	# Changing enemy spawning time
	var time_off: float = (.1 / 12) * arena_difficulty # Every 12 levels (1 min) spawn timer reduced by .1 
	time_off = min(time_off, .75)
	enemy_spawn_timer.wait_time = enemy_spawn_time - time_off
	#enemy_spawn_timer.wait_time = enemy_spawn_timer.wait_time - enemy_spawn_timer.wait_time * DIFFICULTY_INCREASED_RATIO
	
	print("⏰ Enemy Spawn Timer is ", enemy_spawn_timer.wait_time)
	enemy_spawn_timer.start()
