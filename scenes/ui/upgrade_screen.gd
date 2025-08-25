extends CanvasLayer

signal upgrade_selected(upgrade: AbilityUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = $%CardContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect_overlay: ColorRect = $%ColorRectOverlay


func _ready() -> void:
	get_tree().paused = true
	animation_player.play("in")

	#var foreground: Node = GameUtils.get_foreground()
	#var overlay_rect: ColorRect = color_rect_overlay.duplicate()
#
	#if foreground != null:
		#color_rect_overlay.get_parent().remove_child(color_rect_overlay)
		#foreground.add_child(overlay_rect)


func set_ability_upgrades(upgrades: Array[AbilityUpgrade]) -> void:
	var delay: float = 0

	for upgrade in upgrades:
		var card_instance: Node = upgrade_card_scene.instantiate()
		card_container.add_child(card_instance)
		card_instance.set_ability_upgrade(upgrade)

		card_instance.play_in(delay)

		card_instance.selected.connect(on_upgrade_selected.bind(upgrade))

		delay += .2


func on_upgrade_selected(upgrade: AbilityUpgrade) -> void:
	upgrade_selected.emit(upgrade)
	animation_player.play("out")
	await  animation_player.animation_finished
	get_tree().paused = false
	queue_free()
