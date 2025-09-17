extends Node2D

@onready var label: Label = $Label

var in_tween_duration: float = .3
var out_tween_duration: float = .15


func _ready() -> void:
	pass


func pop_damage_text(text: String) -> void:
	label.text = text
	var in_tween: Tween = create_tween()

	in_tween.set_parallel()

	in_tween.tween_property(self, "global_position", global_position + (Vector2.UP * 16), in_tween_duration)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC) # Exacuting EaseOutCubic transition via tween
	in_tween.chain()

	in_tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), in_tween_duration + .2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART) # Exacuting EaseInQuart transition via tween
	in_tween.tween_property(self, "scale", Vector2.ZERO, in_tween_duration + .2)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC) # Exacuting EaseInCubic transition via tween
	in_tween.chain()

	in_tween.tween_callback(queue_free)

	var out_tween: Tween = create_tween()

	out_tween.tween_property(self, "scale", Vector2.ONE * 2.0, out_tween_duration)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC) # Exacuting EaseOutCubic transition via tween
	out_tween.tween_property(self, "scale", Vector2.ONE, out_tween_duration)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC) # Exacuting EaseInCubic transition via tween
