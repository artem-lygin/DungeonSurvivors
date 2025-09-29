extends CanvasLayer

signal transition_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var skip_emit: bool = false

func transition() -> void:
	animation_player.play("deafult")
	await transition_halfway
	skip_emit = true
	animation_player.play_backwards("deafult")


func transition_to_scene(scene_path: String) -> void:
	transition()
	await transition_halfway
	if 	get_tree().paused:
			get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)


func emit_transition_halfway() -> void:
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()
