extends Node

@export var round_end_screen: PackedScene

@onready var player_scene: CharacterBody2D = $%Player


func _ready() -> void:
	#Listen to "died" signal from HealthComponent in the player scene
	player_scene.health_component.died.connect(_on_player_death)


# Show Round End Scene and call "set_defeat" method from the scene
func _on_player_death() -> void:
	var round_end_screen_instance: Node = round_end_screen.instantiate()
	add_child(round_end_screen_instance)
	round_end_screen_instance.set_defeat()
