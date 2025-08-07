extends Camera2D

var target_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()


func _process(_delta: float) -> void:
	acquire_target()
	# global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 10)) #Smoothing of GameCamera position as it in a course
	global_position = target_position


func acquire_target() -> void:
	var player_node: Array = get_tree().get_nodes_in_group("player")
	if player_node.size() > 0:
		var player: Node2D = player_node[0] as Node2D
		target_position = player.global_position
