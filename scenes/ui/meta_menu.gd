extends CanvasLayer

@export var meta_upgrade_card_scene: PackedScene
#TODO move meta_upgrades to meta_progression control
@export var meta_upgrades: Array[MetaUpgrade]

@onready var grid_container_cards: GridContainer = %GridContainerCards


func _ready() -> void:
	for upgrade in meta_upgrades:
		var meta_upgrade_card_instance: PanelContainer = meta_upgrade_card_scene.instantiate()
		grid_container_cards.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(upgrade)
