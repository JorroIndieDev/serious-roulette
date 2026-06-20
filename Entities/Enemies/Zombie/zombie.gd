extends CharacterBody2D

func _ready() -> void:
	$HealthComponent.connect("damaged", _damaged)

func _damaged(dmg:float) -> void:
	$DamageNumberSpawner.spawn_label(dmg)
