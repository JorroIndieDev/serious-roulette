class_name HitBoxComponent extends Area2D

@export var health_component: HealthComponent
@onready var damage_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		damage_sound.play()
	
