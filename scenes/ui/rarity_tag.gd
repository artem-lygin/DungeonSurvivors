extends PanelContainer

@onready var label: Label = $%RarityLabel


func _ready() -> void:
	#var content_size = label.get_content_size()
	self.custom_minimum_size.x = label.size.x + 16
	print(label.size.x)
	print(self.custom_minimum_size.x)
