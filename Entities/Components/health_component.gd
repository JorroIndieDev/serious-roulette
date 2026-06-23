class_name HealthComponent extends Node

@export var BASE_MAX_HEALTH : float = 40.0
var max_health: float
var health : float
var parent: Node2D

signal damaged(attack: Attack)
signal died

func _ready() -> void:
	max_health = BASE_MAX_HEALTH
	health = max_health
	parent = get_parent()

func damage(attack: Attack):
	health -= attack.attack_damage
	emit_signal("damaged", attack)
	if health <= 0:
		#get_parent().queue_free()
		emit_signal("died")
		if parent is Player:
			var p: Player = parent
			p.died()
		else:
			parent.queue_free()
