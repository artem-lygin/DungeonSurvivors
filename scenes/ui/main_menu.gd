extends CanvasLayer

@onready var play_button: SoundButton = %PlayButton
@onready var options_button: SoundButton = %OptionsButton
@onready var quit_button: SoundButton = %QuitButton
@onready var menu_container: MarginContainer = $%MarginContainer

var options_scene: PackedScene = preload("uid://dxyobknrhjnct")


func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)


func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("uid://mfc4mmjxx8ub")


func on_options_button_pressed() -> void:
	var options_menu_instance: Node = options_scene.instantiate()
	menu_container.visible = false
	add_child(options_menu_instance)
	options_menu_instance.back_button_pressed.connect(on_back_button_pressed.bind(options_menu_instance))


func on_quit_button_pressed() -> void:
	get_tree().quit()


func on_back_button_pressed(options_menu_instance: Node) -> void:
	menu_container.visible = true
	options_menu_instance.queue_free()
