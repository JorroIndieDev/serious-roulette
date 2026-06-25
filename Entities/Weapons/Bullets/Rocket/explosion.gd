extends Node2D

@onready var explosion: CPUParticles2D = $ExplosionParticles
@onready var explosion_sound: AudioStreamPlayer2D = $ExplosionSound
var explode_sound: AudioStream

func _ready() -> void:
	explosion.emitting = true
	explosion_sound.stream = explode_sound
	explosion_sound.play()
	await get_tree().create_timer(1).timeout
	self.queue_free()
