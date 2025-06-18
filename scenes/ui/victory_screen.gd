extends CanvasLayer

@onready var restart_button: Button = $%RestartButton
@onready var quit_button: Button = $%QuitButton


func _ready() -> void:
	get_tree().paused = true
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)
	
	
func on_restart_button_pressed():
	get_tree().paused = false
	# get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	get_tree().reload_current_scene()


func on_quit_button_pressed():
	get_tree().quit()
