extends Node

@export var round_end_screen: PackedScene

@onready var player_scene: CharacterBody2D = $%Player

const PAUSE_MENU = preload("res://scenes/ui/pause_menu.tscn")

func _ready() -> void:
	#Listen to "died" signal from HealthComponent in the player scene
	player_scene.health_component.died.connect(_on_player_death)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu_instance: Node = PAUSE_MENU.instantiate()
		add_child(pause_menu_instance)
		get_tree().root.set_input_as_handled()


# Show Round End Scene and call "set_defeat" method from the scene
func _on_player_death() -> void:
	var round_end_screen_instance: Node = round_end_screen.instantiate()
	add_child(round_end_screen_instance)
	round_end_screen_instance.set_defeat()
	MetaProgression.save_to_file()
