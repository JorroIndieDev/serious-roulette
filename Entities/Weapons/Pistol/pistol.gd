extends Node2D

# NEEDS TO CHANGE FOR MORE BULLET TYPES
@onready var bullet := preload("res://Entities/Weapons/BasicBullet/BasicBullet.tscn")


func shoot() -> void:
	var projectile : BasicBullet = bullet.instantiate()
	var attack = Attack.new()
	attack.attack_damage = 1.0
	attack.attack_position = global_position
	attack.knockback_force = 0.0
	projectile.speed = 100.0 
	get_parent().get_parent().get_parent().get_parent().add_child(projectile)
	projectile.transform = %Muzzle.global_transform
	print("Shot")
