class_name HealthComponent extends Node

@export var BASE_MAX_HEALTH : float = 40.0
var max_health: float
var health : float

signal damaged(dmg:float)

func _ready() -> void:
	max_health = BASE_MAX_HEALTH
	health = max_health

func damage(attack: Attack):
	health -= attack.attack_damage
	emit_signal("damaged", attack.attack_damage)
	if health <= 0:
		get_parent().queue_free()
