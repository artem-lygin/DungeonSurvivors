extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.player_damadged.connect(on_player_damadged)
	animation_player.play("RESET")


func on_player_damadged() -> void:
	animation_player.play("hit")
