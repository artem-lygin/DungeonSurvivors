extends AudioStreamPlayer2D
class_name HitAudioComponent

@export var hurtbox_component: HurboxComponent

@onready var hit_audio_component: HitAudioComponent = $"."

func _ready() -> void:
	hurtbox_component.hit.connect(on_hit)


func on_hit() -> void:
	#print("Hit sound stream: %s | Volume: %f | Bus: %s" % [stream, volume_db, bus])
	hit_audio_component.play()
