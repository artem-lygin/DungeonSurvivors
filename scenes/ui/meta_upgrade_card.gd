extends PanelContainer

#signal selected

@export var hover_sounds: AudioStreamRandomizer
@export var select_sounds: AudioStreamRandomizer
@onready var name_label: Label = $%NameLabel
@onready var rarity_tag: Label = $%RarityTag
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player: AnimationPlayer = $%AnimationPlayer
@onready var interaction_animation_player: AnimationPlayer = $%InteractionAnimationPlayer
@onready var audio_player: AudioStreamPlayer = %AudioStreamPlayer

@onready var exp_progress_bar: TextureProgressBar = %ExpProgressBar
@onready var cost_label: Label = %CostLabel

@onready var purchase_button: Button = %PurchaseButton

@onready var next_card: Control
@onready var prev_card: Control

#var diasabled: bool = false
var meta_upgrade: MetaUpgrade


func _ready() -> void:
	self.gui_input.connect(on_gui_input)
	purchase_button.pressed.connect(on_purchase_pressed)
	#self.mouse_entered.connect(on_mouse_entered)
	#self.mouse_exited.connect(on_mouse_exited)
	#self.material.set_shader_parameter("outline_visible", 1.0)
	self.pivot_offset = self.size / 2


func update_ui_progress() -> void:
	var current_meta_currency_ammount: int = MetaProgression.get_meta_currency()

	self.exp_progress_bar.value = clamp(float(current_meta_currency_ammount) / meta_upgrade.resource_cost, 0.0, 1.0)
	self.cost_label.text = str(current_meta_currency_ammount) + "/" + str(meta_upgrade.resource_cost)
	if meta_upgrade.resource_cost > current_meta_currency_ammount:
		purchase_button.disabled = true
		purchase_button.text = "Not enough exp"


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	self.meta_upgrade = upgrade
	self.add_theme_stylebox_override("panel", upgrade.get_card_stylebox())
	self.name_label.text = upgrade.title
	self.rarity_tag.text = upgrade.rarity_to_string().capitalize()
	self.rarity_tag.add_theme_color_override("font_color", upgrade.get_rarity_color())
	self.rarity_tag.add_theme_stylebox_override("normal", upgrade.get_tag_stylebox())
	self.description_label.text = upgrade.description
	self.material = upgrade.get_rarity_effect()
	update_ui_progress()


func on_gui_input(_event: InputEvent) -> void:
	pass
	#if diasabled:
		#return
	#if event.is_action_pressed("lmb_click"):
		#select_card()


func on_purchase_pressed() -> void:
	if meta_upgrade == null:
		return
	MetaProgression.add_meta_upgrade(meta_upgrade)
	select_card()
	get_tree().call_group("meta_upgrade_card", "update_ui_progress")


#func on_mouse_entered() -> void:
	#if diasabled:
		#return
#
	#audio_player.stream = hover_sounds
	#audio_player.play()
	#interaction_animation_player.play("hover")
	#self.material.set_shader_parameter("outline_visible", 1.0)


#func on_mouse_exited() -> void:
	#self.material.set_shader_parameter("outline_visible", 0.0)


func select_card() -> void:
	#diasabled = true
	audio_player.stream = select_sounds
	audio_player.play()
	interaction_animation_player.play("purchase")

	await interaction_animation_player.animation_finished


func play_discard() -> void:
	animation_player.play("discard")
	await animation_player.animation_finished


func play_in(delay: float = 0.1) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")
