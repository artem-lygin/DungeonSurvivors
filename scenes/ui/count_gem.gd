extends TextureRect
class_name OwningCounterGem

@onready var gem: TextureRect = %TextureRect
var is_enabled: bool

func _ready() -> void:
	gem.visible = false
	is_enabled = false


func set_enabled() -> void:
	gem.visible = true
	is_enabled = true
	var in_tween: Tween = create_tween()
	in_tween.tween_property(gem, "scale", Vector2.ONE, .4).from(Vector2.ZERO).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	await in_tween.finished
	in_tween.kill()


func set_disabled() -> void:
	var out_tween: Tween = create_tween()
	out_tween.tween_property(gem, "scale", Vector2.ZERO, .4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	await out_tween.finished
	out_tween.kill()
	gem.visible = false
	is_enabled = false
