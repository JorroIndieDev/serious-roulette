class_name DeadSmoke extends Node2D

@onready var smoke: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	smoke.emitting = true
	await smoke.finished
	self.queue_free()
