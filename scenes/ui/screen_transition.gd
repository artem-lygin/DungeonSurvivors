extends CanvasLayer

signal transition_halfway

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var skip_emit: bool = false

func tranition() -> void:
	animation_player.play("deafult")
	await transition_halfway
	skip_emit = true
	animation_player.play_backwards("deafult")


func emit_transition_halfway() -> void:
	if skip_emit:
		skip_emit = false
		return
	transition_halfway.emit()
