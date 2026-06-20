class_name HitBoxComponent extends Area2D

@export var health_component: HealthComponent

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		print(attack.attack_damage)

func _display_damage(dmg: float) -> void:
	pass
