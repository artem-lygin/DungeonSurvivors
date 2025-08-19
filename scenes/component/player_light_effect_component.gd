extends Node2D

@onready var player_light: PointLight2D = %PlayerPointLight2D
@onready var player_light_texture: GradientTexture2D = (player_light.texture as Texture2D).duplicate()

var player_light_radius: int = 240
var current_player_light_radius: int

func _ready() -> void:
	## Tourch light effect
	#TODO Set in _ready and call method to change the size
	current_player_light_radius = round(player_light_texture.get_width() / 2.0)
	player_light_texture.width = player_light_radius * 2
	player_light_texture.height = player_light_radius

	player_light.texture = player_light_texture as Texture2D

func _process(_delta: float) -> void:

	if (player_light_radius != current_player_light_radius) && (player_light_texture != null):
		print("Light radius is updated")
		player_light.texture = player_light_texture as Texture2D

	# Tourch light flickering
	var flick_timer: float = Time.get_ticks_msec() / 1000.0
	var wave: float = sin(flick_timer * 4.0 * TAU) * 0.5 + 0.5  # from 0 to 1
	player_light.energy = lerp(1.8, 2.0, wave)
	# player_light.color = player_base_color + Color(randf_range(-0.05, 0.05), randf_range(-0.03, 0.03), 0.0)
