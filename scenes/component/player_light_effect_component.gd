extends Node2D

signal player_light_disabled(state: bool)

const PLAYER_LIGHT_MIN_RADIUS: int = 32
const PLAYER_LIGHT_MAX_RADIUS: int = 480

@onready var player_light_source_1: PointLight2D = %PlayerPointLight2D
@onready var player_light_texture: GradientTexture2D = (player_light_source_1.texture as Texture2D).duplicate()

var debug_draw: bool = ProjectSettings.get_setting("game/debug/player/debug_draw")

## Light radius = texture.height and 2* texture.width
var player_light_enabled: bool = true

var player_light_radius: int

var light_cumulative_energy: float = 2.0
var light_intencity: float = 1.0
var light_intencity_deviation: float = 0.25
var lights_position_deviation: int = 16

var light_dimming_rate: float = 10.0
var light_dimming_value: int = 12

var player_lights_array: Array = []



func _ready() -> void:
	# Prepere PointLight2D array
	@warning_ignore("integer_division")
	player_light_radius = PLAYER_LIGHT_MAX_RADIUS / 2
	player_lights_array = get_tree().get_nodes_in_group("player_light")

	#TODO Set in _ready and call method to change the size
	#current_player_light_radius = round(player_light_texture.get_width() / 2.0)

	set_player_light_radius(player_light_radius)
	dimm_light_by_time()

	for light_source: PointLight2D in player_lights_array:
		set_player_light_intencity(light_intencity, light_source)
		set_random_light_position(light_source)


func _process(_delta: float) -> void:
	queue_redraw()


#TODO sets same intencity for all, we need set individually
## Evenly sets the energy of all light sources in "player_light" group, cap it to "light_cumulative_energy" in total
## "intencity" should be within 0.0 to 1.0
func set_player_light_intencity(_intencity: float, _light_source: PointLight2D) -> void:
	if player_lights_array == []:
		return

	var intencity_tween: Tween = create_tween()

	var sources_quantity: int = player_lights_array.size()
	var energy_per_source: float = lerp(0.0, light_cumulative_energy, clamp(_intencity, 0.0, 1.0) / sources_quantity )
	var target_energy: float = randf_range(energy_per_source - light_intencity_deviation, energy_per_source + light_intencity_deviation)

	intencity_tween.tween_property(_light_source, "energy", target_energy, randf_range(0.05, 0.4))\
	.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	intencity_tween.finished.connect(func() -> void:
		set_player_light_intencity(_intencity, _light_source)
		)


## Set tween for light_source changing the position to
func set_random_light_position(light_source: Node2D) -> void:

	var position_tween: Tween = create_tween()
	var target_position: Vector2 = GameUtils.get_random_point_in_radius(lights_position_deviation, Vector2.ZERO, true)
	position_tween.tween_property(light_source, "position", target_position, randf_range(0.05, 0.4))\
	.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	position_tween.finished.connect(
		func() -> void:
		set_random_light_position(light_source)
		)


func dimm_light_by_time() -> void:
	player_light_radius -= light_dimming_value
	if player_light_radius <= PLAYER_LIGHT_MIN_RADIUS:
		print("lights should be disabled now")
		player_light_disabled.emit(true)
		return
	else:
		set_player_light_radius(player_light_radius)

	get_tree().create_timer(light_dimming_rate).timeout.connect(dimm_light_by_time)


func set_player_light_radius(_radius: int) -> void:
	if player_lights_array == []:
		return

	for _light_source: PointLight2D in player_lights_array:
		set_light_source_size(_light_source, _radius)


func set_light_source_size(_light_source: PointLight2D, _size: float) -> void:
	var _player_light_texture: GradientTexture2D = _light_source.texture as Texture2D

	var size_tween: Tween = create_tween().set_parallel()

	size_tween.tween_property(_player_light_texture, "width", _size * 2, 0.8)\
	.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	size_tween.tween_property(_player_light_texture, "height", _size, 0.8)\
	.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _draw() -> void:
	if debug_draw:
		for light: Node2D in player_lights_array:
			draw_circle(light.position, 1.0, Color.ORANGE)
