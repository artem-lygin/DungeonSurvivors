extends Node2D

@export var health_component: Node
@export var enemy_sprite: Sprite2D

@onready var animation_player: AnimationPlayer = $%AnimationPlayer
@onready var particles_node: GPUParticles2D = $%GPUParticles2D


func _ready() -> void:
	particles_node.texture = enemy_sprite.texture
	health_component.died.connect(_on_died)


func _on_died() -> void:
	if owner == null || not owner is Node2D: return
	var spawn_position: Vector2 = owner.global_position

	var entities_layer: Node = get_tree().get_first_node_in_group("entities_layer")
	get_parent().remove_child(self)
	entities_layer.add_child(self)

	self.global_position = spawn_position
	animation_player.play("death")
