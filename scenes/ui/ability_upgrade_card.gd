extends PanelContainer

signal selected

@export var hover_sounds: AudioStreamRandomizer
@export var select_sounds: AudioStreamRandomizer
@onready var name_label: Label = $%NameLabel
@onready var rarity_tag: Label = $%RarityTag
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player: AnimationPlayer = $%AnimationPlayer
@onready var interaction_animation_player: AnimationPlayer = $%InteractionAnimationPlayer
@onready var audio_player: AudioStreamPlayer = %AudioStreamPlayer


@onready var select_button: Button = $%SelectButton

@onready var next_card: Control
@onready var prev_card: Control

var diasabled: bool = false


func _ready() -> void:
	self.gui_input.connect(on_gui_input)
	self.mouse_entered.connect(on_mouse_entered)
	self.mouse_exited.connect(on_mouse_exited)

	self.pivot_offset = self.size / 2


func on_gui_input(event: InputEvent) -> void:
	if diasabled:
		return

	if event.is_action_pressed("lmb_click"):
		select_card()


func on_mouse_entered() -> void:
	if diasabled:
		return

	audio_player.stream = hover_sounds
	audio_player.play()
	interaction_animation_player.play("hover")


func on_mouse_exited() -> void:
	pass


func select_card() -> void:
	diasabled = true
	audio_player.stream = select_sounds
	audio_player.play()
	interaction_animation_player.play("click")
	discard_cards()
	await interaction_animation_player.animation_finished
	selected.emit()


func discard_cards() -> void:
	var upgrade_cards: Array = get_tree().get_nodes_in_group("upgrade_card")

	for upgrade_card: PanelContainer in upgrade_cards:
		if upgrade_card == self:
			continue
		upgrade_card.play_discard()


func play_discard() -> void:
	animation_player.play("discard")
	await animation_player.animation_finished


func set_ability_upgrade(upgrade: AbilityUpgrade) -> void:
	name_label.text = upgrade.name
	rarity_tag.text = upgrade.rarity_to_string().capitalize()
	rarity_tag.add_theme_color_override("font_color", upgrade.get_rarity_color())
	rarity_tag.add_theme_stylebox_override("normal", upgrade.get_rarity_stylebox())
	description_label.text = upgrade.description


func play_in(delay: float = 0) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")
