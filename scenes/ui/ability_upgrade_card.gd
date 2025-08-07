extends PanelContainer

signal selected

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var select_button: Button = $%SelectButton
@onready var next_card: Control
@onready var prev_card: Control


func _ready() -> void:
	gui_input.connect(on_gui_input)


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("lmb_click"):
		selected.emit()


func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text = upgrade.name
	description_label.text = upgrade.description
