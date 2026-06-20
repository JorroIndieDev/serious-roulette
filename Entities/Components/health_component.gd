class_name HealthComponent extends Node

@export var MAX_HEALTH : float = 40.0
var health : float

signal damaged(dmg:float)

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	emit_signal("damaged", attack.attack_damage)
	if health <= 0:
		get_parent().queue_free()
