extends AudioStreamPlayer

@onready var timer: Timer = $Timer


func _ready() -> void:
	self.finished.connect(on_stream_finished)
	timer.timeout.connect(on_timer_timeout)


func on_stream_finished() -> void:
	timer.start()


func on_timer_timeout() -> void:
	self.play()
