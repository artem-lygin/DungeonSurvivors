extends Node

# TODO modify spawn_radius going to be set from current resolution of viewport
const SPAWN_RADIUS: int = 420 # Should be half of current viewport diagonal
const DIFFICULTY_INCREASED_RATIO = 0.1

@export var arena_time_manager: Node

@export var enemies_pool: Dictionary[String, PackedScene]
@export var enemies_weights_table: Dictionary[String, int]

@onready var enemy_spawn_timer: Timer = $Timer

var enemy_spawn_time: float = 0
var enemy_table: WeightedTable = WeightedTable.new()


func _ready() -> void:
	update_enemy_pool("rat")
	enemy_spawn_time = enemy_spawn_timer.wait_time
	enemy_spawn_timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)


func update_enemy_pool(type: String) -> void:
		enemy_table.add_item(enemies_pool[type], enemies_weights_table[type])


func get_spawn_position () -> Vector2: # Defining the plase of enemy spawn
	var player: Node2D = GameUtils.get_player() as Node2D

	if player == null: #safecheck
		return Vector2.ZERO

	var spawn_position: Vector2 = player.global_position
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))

	for i in 4: # for loop is not inclusive: i < 4
		spawn_position =  player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_offset: Vector2 = random_direction * 20
		# Querying the *direct space state* (current state of physics objects in the game)
		var query_parameters: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(player.global_position,\
		spawn_position + additional_offset, 1 << 0)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)

		if result.is_empty():
			# raycast to spawn_position did not met any collisions and it safe to spawn an enemy and exit the loop
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position


func on_timer_timeout() -> void:
	enemy_spawn_timer.start() # Handling staring the timer here to be able to change it wait_time

	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return

	# Instantiate basic enemy node into the scene
	var enemy_scene: PackedScene = enemy_table.pick_item() as PackedScene
	var enemy: Node2D = enemy_scene.instantiate() as Node2D
	enemy.name = "BasicEnemy_%d" % get_tree().get_nodes_in_group("enemy").size()

	var entities_layer: Variant = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null: return
	entities_layer.add_child(enemy) #add the scene as child node of "Main" node
	enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int) -> void:
	# Changing enemy spawning time
	var time_off: float = (.1 / 12) * arena_difficulty # Every 12 levels (1 min) spawn timer reduced by .1
	time_off = min(time_off, .75)
	enemy_spawn_timer.wait_time = enemy_spawn_time - time_off

	if arena_difficulty == 6:
		enemy_table.add_item(enemies_pool["wizard"], enemies_weights_table["wizard"])
	elif arena_difficulty == 12:
		enemy_table.add_item(enemies_pool["bat"], enemies_weights_table["bat"])

	#print("⏰ Enemy Spawn Timer is ", enemy_spawn_timer.wait_time)
	enemy_spawn_timer.start()
