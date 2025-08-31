extends CanvasLayer

@onready var restart_button: Button = $%RestartSoundButton
@onready var quit_button: Button = $%QuitSoundButton
@onready var title_label: Label = $%TitleLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var panel_container: PanelContainer = $%PanelContainer

var in_tween_duration: float = .3


func _ready() -> void:
	panel_container.pivot_offset = panel_container.size / 2
	#panel_container.scale = Vector2.ZERO

	var in_tween: Tween = create_tween()
	in_tween.tween_property(panel_container, "scale", Vector2.ZERO, 0)
	in_tween.tween_property(panel_container, "scale", Vector2.ONE, in_tween_duration
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

func set_defeat() -> void:

	title_label.text = "Defeat!"
	title_label.label_settings.font_color = Color.INDIAN_RED
	description_label.text = "You've lost this round"


func on_restart_button_pressed() -> void:
	get_tree().paused = false
	# get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	get_tree().reload_current_scene()


func on_quit_button_pressed() -> void:
	get_tree().quit()
