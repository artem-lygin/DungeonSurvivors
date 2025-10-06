extends CanvasLayer

@onready var resume_button: SoundButton = %ResumeButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_button: SoundButton = %QuitButton
@onready var pause_menu_container: PanelContainer = %PauseMenuContainer
@onready var animation_player: AnimationPlayer = %AnimationPlayer

const OPTIONS_SCENE: PackedScene = preload(Paths.OPTIONS_MENU_SCREEN)
const MAIN_MENU: PackedScene = preload(Paths.MAIN_MENU_SCENE)

var in_tween: Tween
var out_tween: Tween
var in_tween_duration: float = 0.30


func _ready() -> void:
	get_tree().paused = true
	resume_button.pressed.connect(on_resume_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

	pause_menu_container.pivot_offset = pause_menu_container.size / 2
	in_tween = create_tween()

	in_tween.tween_property(pause_menu_container, "scale", Vector2.ONE, in_tween_duration).from(Vector2.ZERO)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	await in_tween.finished
	in_tween.kill()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close_pause_menu()
		get_tree().root.set_input_as_handled()


func close_pause_menu() -> void:
	out_tween = create_tween()
	out_tween.tween_property(pause_menu_container, "scale", Vector2.ZERO, in_tween_duration / 2 )\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	animation_player.play("out")
	await animation_player.animation_finished
	get_tree().paused = false
	queue_free()


func on_resume_button_pressed() -> void:
	close_pause_menu()


func on_options_button_pressed() -> void:
	var options_menu_instance: Node = OPTIONS_SCENE.instantiate()
	pause_menu_container.visible = false
	add_child(options_menu_instance)
	options_menu_instance.back_button_pressed.connect(on_options_back_button_pressed.bind(options_menu_instance))


func on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(MAIN_MENU)


func on_options_back_button_pressed(options_menu_instance: Node) -> void:
	pause_menu_container.visible = true
	options_menu_instance.queue_free()
