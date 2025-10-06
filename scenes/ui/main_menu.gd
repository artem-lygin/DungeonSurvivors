extends CanvasLayer

@onready var play_button: SoundButton = %PlayButton
@onready var options_button: SoundButton = %OptionsButton
@onready var meta_store_button: SoundButton = %MetaStoreButton
@onready var quit_button: SoundButton = %QuitButton
@onready var menu_container: MarginContainer = $%MarginContainer

const OPTIONS_SCENE = preload(Paths.OPTIONS_MENU_SCREEN)

func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	meta_store_button.pressed.connect(on_meta_store_button_pressed)
	options_button.pressed.connect(on_options_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

	# TODO Set audio to .75 on first load via gloabl variables
	#AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("music"), .75)
	#AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("sfx"), .75)


func on_play_button_pressed() -> void:
	ScreenTransition.transition_to_scene(Paths.MAIN_PLAY_SCENE)


func on_options_button_pressed() -> void:
	var options_menu_instance: Node = OPTIONS_SCENE.instantiate()
	menu_container.visible = false
	add_child(options_menu_instance)
	options_menu_instance.back_button_pressed.connect(on_back_button_pressed.bind(options_menu_instance))


func on_meta_store_button_pressed() -> void:
	ScreenTransition.transition_to_scene(Paths.META_STORE_SCENE)
	#var meta_store_menu_instance: Node = META_STORE_SCENE.instantiate()
	#menu_container.visible = false
	#add_child(meta_store_menu_instance)
	#meta_store_menu_instance.back_button_pressed.connect(on_back_button_pressed.bind(meta_store_menu_instance))


func on_quit_button_pressed() -> void:
	get_tree().quit()


func on_back_button_pressed(menu_instance: Node) -> void:
	menu_container.visible = true
	menu_instance.queue_free()
