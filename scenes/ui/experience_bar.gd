extends CanvasLayer

@export var experience_manager: Node
@export var mobile_size: bool = false

@onready var progress_bar_simple: ProgressBar = $%ProgressBar
@onready var progress_bar: TextureProgressBar = $%TextureProgressBar
@onready var update_effect: CPUParticles2D = %ExpUpdatedEffect
@onready var level_label: Label = %Label


var tween_time: float = .15
var level_up_tween_time: float = .2


func _ready() -> void:
	level_label.text = str(experience_manager.current_level)

	progress_bar.value = 0
	progress_bar_simple.value = 0

	update_effect.position = Vector2(0, 6)
	update_effect.lifetime = tween_time * 4
	update_effect.preprocess = tween_time
	experience_manager.experience_updated.connect(on_experience_updated)
	experience_manager.level_up.connect(on_level_up)


func on_experience_updated(current_experience: float, target_experience: float) -> void:
	var percentage: float = current_experience / target_experience

	var progressbar_tween: Tween = create_tween()

	progressbar_tween.parallel()
	progressbar_tween.tween_property(progress_bar, "value", percentage, tween_time)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

	progress_bar_simple.value = percentage

	progressbar_tween.tween_property(progress_bar, "tint_progress", Color(1.2, 1.6, 2.0), tween_time)
	progressbar_tween.chain()

	progressbar_tween.tween_property(progress_bar, "tint_progress", Color(1.0, 1.0, 1.0), tween_time*8 )

	# Defining effect position and emitting
	var progress_bar_size: Vector2 = progress_bar.size
	var effect_position_x: float = lerp(0, int(progress_bar_size.x - 5), percentage)

	var effect_position_tween: Tween = create_tween()
	effect_position_tween.tween_property(update_effect, "position", Vector2(effect_position_x, 0) , tween_time)
	emit_effect()


func on_level_up(level: int) -> void:
	level_label.text = str(level)
	var tween: Tween = create_tween()
	#var label_pos: Vector2 = level_label.global_position

	#tween.set_parallel()
	#tween.tween_property(level_label, "global_position", label_pos + (Vector2.UP * 20), level_up_tween_time
	#).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(level_label, "scale", Vector2(2.5, 2.5), level_up_tween_time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

	#tween.chain()
	tween.tween_interval(0.3)

	#tween.set_parallel()
	#tween.tween_property(level_label, "global_position", label_pos, level_up_tween_time
	#).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(level_label, "scale", Vector2(1.0, 1.0), level_up_tween_time
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)

func emit_effect() -> void:
	update_effect.emitting = true
