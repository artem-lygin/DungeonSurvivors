extends CanvasLayer

@export var sound_win: AudioStream
@export var sound_lose: AudioStream

@onready var continue_button: Button = %ContinueSoundButton
@onready var quit_button: Button = %QuitSoundButton
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var panel_container: PanelContainer = %PanelContainer
@onready var audio_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var in_tween_duration: float = 0.4
var in_tween: Tween

func _ready() -> void:
	continue_button.pressed.connect(on_continue_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

	panel_container.pivot_offset = panel_container.size / 4 # why it works?

	audio_player.stream = sound_win
	panel_container.modulate = Color(0, 0, 0, 0)

	in_tween = create_tween()
	#in_tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	in_tween.set_parallel()
	in_tween.tween_property(panel_container, "scale", Vector2.ONE, in_tween_duration)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).from(Vector2.ZERO)
	in_tween.tween_property(panel_container, "modulate", Color.WHITE, in_tween_duration / 2)

	get_tree().paused = true

func set_defeat() -> void:
	audio_player.stream = sound_lose
	#audio_player.play()
	title_label.text = "Defeat!"
	title_label.label_settings.font_color = Color.INDIAN_RED
	description_label.text = "You've lost this round"


func on_continue_button_pressed() -> void:
	await ScreenTransition.transition_to_scene(Paths.META_STORE_SCENE)


func on_quit_button_pressed() -> void:
	ScreenTransition.transition_to_scene(Paths.MAIN_MENU_SCENE)
