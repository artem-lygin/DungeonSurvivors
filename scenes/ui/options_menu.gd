extends CanvasLayer

signal back_button_pressed

@onready var sfx_slider: HSlider = %SfxSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var window_mode_button: SoundButton = %WindowModeButton
@onready var back_button: SoundButton = %BackButton


func _ready() -> void:
	sfx_slider.value_changed.connect(on_audio_slider_value_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_slider_value_changed.bind("music"))
	window_mode_button.pressed.connect(on_window_mode_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)

	update_display()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		on_back_button_pressed()
		get_tree().root.set_input_as_handled()


func update_display() -> void:
	var window_mode: int = DisplayServer.window_get_mode()
	if window_mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_mode_button.text = "Set Fullscreen"
	else:
		window_mode_button.text = "Set Windowed"

	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")


func set_bus_volume_percent(bus_name: String, value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_linear(bus_index, value)


func get_bus_volume_percent(bus_name: String) -> float:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	var bus_volume_linear: float = AudioServer.get_bus_volume_linear(bus_index)
	return bus_volume_linear


func on_audio_slider_value_changed(value: float, bus_name: String) -> void:
	set_bus_volume_percent(bus_name, value)


func on_window_mode_button_pressed() -> void:
	var window_mode: int = DisplayServer.window_get_mode()
	if window_mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	update_display()


func on_back_button_pressed() -> void:
	get_tree().create_timer(0.05).timeout.connect(
		func() -> void:
			self.back_button_pressed.emit()
			)
