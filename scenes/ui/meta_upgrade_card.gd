extends PanelContainer

#signal selected

@export var hover_sounds: AudioStreamRandomizer
@export var select_sounds: AudioStreamRandomizer
@export var count_gem_scene: PackedScene

@onready var name_label: Label = $%NameLabel
@onready var rarity_tag: Label = $%RarityTag
@onready var description_label: Label = $%DescriptionLabel
@onready var animation_player: AnimationPlayer = $%AnimationPlayer
@onready var interaction_animation_player: AnimationPlayer = $%InteractionAnimationPlayer
@onready var audio_player: AudioStreamPlayer = %AudioStreamPlayer

@onready var exp_progress_bar: TextureProgressBar = %ExpProgressBar
@onready var count_container: HBoxContainer = %CountContainer

@onready var cost_label: Label = %CostLabel

@onready var purchase_button: Button = %PurchaseButton
var purchase_button_text: String

@onready var next_card: Control
@onready var prev_card: Control

var debug_log: bool = ProjectSettings.get_setting("game/debug/meta_progress/debug_log")

#var diasabled: bool = false
var meta_upgrade: MetaUpgrade
var counter_gem_array: Array [OwningCounterGem]


func _ready() -> void:
	self.gui_input.connect(on_gui_input)
	purchase_button.pressed.connect(on_purchase_pressed)
	purchase_button_text = purchase_button.text
	#self.mouse_entered.connect(on_mouse_entered)
	#self.mouse_exited.connect(on_mouse_exited)
	#self.material.set_shader_parameter("outline_visible", 1.0)
	self.pivot_offset = self.size / 2


func update_ui_progress() -> void:
	var current_meta_currency_amount: int = MetaProgression.get_meta_currency()
	var meta_upgrade_owned_amount: int = MetaProgression.get_meta_upgrade_owned_amount(meta_upgrade)

	var label_tween: Tween
	var progressbar_tween: Tween

	var target_currency_amount: String = str(current_meta_currency_amount) + "/" + str(meta_upgrade.resource_cost)
	var target_progressbar_value: float = clamp(float(current_meta_currency_amount) / meta_upgrade.resource_cost, 0.0, 1.0)
	#self.exp_progress_bar.value = target_progressbar_value
	label_tween = create_tween()
	label_tween.tween_property(cost_label,"text", target_currency_amount, 0.5)
	progressbar_tween = create_tween()
	progressbar_tween.tween_property(exp_progress_bar, "value", target_progressbar_value, 0.5)

	if meta_upgrade_owned_amount > 0:
		for counter in meta_upgrade_owned_amount:
			if not counter_gem_array[counter].is_enabled:
				counter_gem_array[counter].set_enabled()
	else:
		for counter in counter_gem_array:
			counter.set_disabled()

	#TODO Refactor using if...elif
	if meta_upgrade_owned_amount >= meta_upgrade.max_quantity:
		purchase_button.disabled = true
		purchase_button.text = "Max amout owned"

	if meta_upgrade.resource_cost > current_meta_currency_amount:
		purchase_button.disabled = true
		purchase_button.text = "Not enough exp"

	if meta_upgrade_owned_amount < meta_upgrade.max_quantity and meta_upgrade.resource_cost <= current_meta_currency_amount:
		purchase_button.disabled = false
		purchase_button.text = purchase_button_text


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	self.meta_upgrade = upgrade
	self.add_theme_stylebox_override("panel", upgrade.get_card_stylebox())
	self.name_label.text = upgrade.title
	self.rarity_tag.text = upgrade.rarity_to_string().capitalize()
	self.rarity_tag.add_theme_color_override("font_color", upgrade.get_rarity_color())
	self.rarity_tag.add_theme_stylebox_override("normal", upgrade.get_tag_stylebox())
	self.description_label.text = upgrade.description
	self.material = upgrade.get_rarity_effect()

	var max_amount_owned: int = meta_upgrade.max_quantity
	for count in max_amount_owned:
		var count_gem_instance: Node = count_gem_scene.instantiate()
		counter_gem_array.append(count_gem_instance)
		count_container.add_child(count_gem_instance)

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


func reset_ui_progress() -> void:
	pass

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
	audio_player.stream = select_sounds
	audio_player.play()
	interaction_animation_player.play("purchase")

	await interaction_animation_player.animation_finished


func play_in(delay: float = 0.1) -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	animation_player.play("in")
