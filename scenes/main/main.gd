extends Node

@export var round_end_screen: PackedScene 

@onready var player_scene: CharacterBody2D = $%Player

func _ready() -> void:
	player_scene.health_component.died.connect(_on_player_death)
	
	
func _on_player_death():
	var round_end_screen_instance = round_end_screen.instantiate()
	add_child(round_end_screen_instance)
	round_end_screen_instance.set_defeat()
