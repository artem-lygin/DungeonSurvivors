extends CanvasLayer

@export var meta_upgrade_card_scene: PackedScene
#TODO move meta_upgrades to meta_progression control
@export var meta_upgrades_pool: Array[MetaUpgrade]

@onready var grid_container_cards: GridContainer = %GridContainerCards
@onready var reset_button: SoundButton = %ResetButton
@onready var back_button: SoundButton = %BackButton
@onready var animation_player: AnimationPlayer = %AnimationPlayer
#@onready var currency_balance_label: Label = %CurrencyBalanceLabel
@onready var balance_counter: CounterUIComponent = %BalanceCounter



var debug_log: bool = ProjectSettings.get_setting("game/debug/meta_progress/debug_log")
var debug_draw: bool = ProjectSettings.get_setting("game/debug/meta_progress/debug_draw")


func _ready() -> void:
	for child in grid_container_cards.get_children():
		child.queue_free()

	MetaProgression.meta_currency_updated.connect(update_ui)
	reset_button.pressed.connect(reset_upgrades)
	back_button.pressed.connect(on_back_button_pressed)

	update_ui(MetaProgression.get_meta_currency())

	for upgrade in meta_upgrades_pool:
		await _add_card_smoother(upgrade)


func _add_card_smoother(_meta_upgrade: MetaUpgrade) -> void:
	var card_size: Vector2 = Vector2(140.0, 205.0)
	var place_holder:= Control.new()
	place_holder.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	place_holder.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	place_holder.pivot_offset = place_holder.size / 2
	place_holder.custom_minimum_size = Vector2.ZERO
	grid_container_cards.add_child(place_holder)

	await get_tree().process_frame

	if debug_draw: draw_placeholder(place_holder)

	var smooth_tween: Tween = create_tween()
	smooth_tween.tween_property(place_holder, "custom_minimum_size", card_size, 0.1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await smooth_tween.finished

	var meta_upgrade_card_instance: PanelContainer = meta_upgrade_card_scene.instantiate()
	place_holder.add_child(meta_upgrade_card_instance)
	meta_upgrade_card_instance.set_meta_upgrade(_meta_upgrade)

	await get_tree().create_timer(0.1).timeout


func reset_upgrades() -> void:
	#TODO Add confirmation
	var owned_upgrades: Dictionary = MetaProgression.get_meta_upgrades_owned()
	var total_upgrades_cost: int = 0

	if owned_upgrades == {}:
		return

	for upgrade: String in owned_upgrades:
		total_upgrades_cost += owned_upgrades[upgrade]["total_cost"]

	if debug_log: print("%d resource restored" % total_upgrades_cost)

	MetaProgression.set_meta_currency(MetaProgression.get_meta_currency() + total_upgrades_cost)
	MetaProgression.reset_meta_upgrades()

	get_tree().call_group("meta_upgrade_card", "update_ui_progress")


func update_ui(balance: int) -> void:
	balance_counter.set_couner_value(balance)


## TODO make Back button work as "Back to source_scene"
func on_back_button_pressed() -> void:
	ScreenTransition.transition_to_scene(Paths.MAIN_MENU_SCENE)


func draw_placeholder(place_holder: Control)  -> void:
	var debug_rect := ColorRect.new()
	#region debug_rect settings
	debug_rect.color = Color.RED
	debug_rect.anchor_left = 0
	debug_rect.anchor_top = 0
	debug_rect.anchor_right = 1
	debug_rect.anchor_bottom = 1
	debug_rect.offset_left = 0
	debug_rect.offset_top = 0
	debug_rect.offset_right = 0
	debug_rect.offset_bottom = 0
	#endregion
	place_holder.add_child(debug_rect)
