extends AudioStreamPlayer2D
class_name LootAudioComponent

@export var expiriance_manager: Node


func _ready() -> void:
	#GameEvents.expirience_vial_collected.connect(on_exp_vial_collected)
	expiriance_manager.experience_updated.connect(on_exp_vial_collected)



func on_exp_vial_collected(_current_exp: float, _target_exp: float) -> void:
	var player_node: Node2D = GameUtils.get_player() as Node2D
	self.position = player_node.global_position
	var ratio: float = 1.0

	if _current_exp != 0:
		ratio = clamp(_current_exp / _target_exp, 0.0, 1.0)

	self.pitch_scale = lerp(0.8, 2.5, ratio)

	self.play()
