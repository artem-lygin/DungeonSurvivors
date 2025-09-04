extends Button
class_name SoundButton

@onready var audio_stream_player: AudioStreamPlayer = $%AudioStreamPlayer

func _ready() -> void:
	self.pressed.connect(on_button_pressed)


func on_button_pressed() -> void:
	audio_stream_player.play()
