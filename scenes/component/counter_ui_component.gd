extends MarginContainer
class_name CounterUIComponent

@onready var texture_rect: TextureRect = %TextureRect
@onready var counter_label: Label = %CounterLabel

@export var counter_texture: Texture2D


func _ready() -> void:
	set_counter_texture(counter_texture)


func set_couner_value(_value: Variant) -> void:
	var current_label_value: int = int(counter_label.text) if counter_label.text.is_valid_int() else 0

	var change_label_tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)

	change_label_tween.parallel()

	change_label_tween.tween_method(
		func(value: int) -> void:
			counter_label.text = str(value),
			current_label_value, _value, 0.6
	)


func set_counter_texture(_texture: Texture2D) -> void:
	if _texture == null:
		return

	texture_rect.texture = _texture
