extends CharacterBody2D

@onready var player : CharacterBody2D = $"../Player"
@export var follow_k : float = 3.0
@export var max_speed: float = 150.0
@export var hitbox: HitBoxComponent


func _ready() -> void:
	$HealthComponent.connect("damaged", _damaged)
	if hitbox:
		hitbox.connect("area_entered", melee)

func _damaged(dmg:float) -> void:
	$DamageNumberSpawner.spawn_label(dmg)

func pathfind():
	if player:
		var distance = player.global_position - global_position
		
		var raw_velocity = distance * follow_k
		
		velocity = raw_velocity.limit_length(max_speed)
		
		move_and_slide()
			
func melee(area: Area2D) -> void: 
	print("melee")
	if area is HitBoxComponent and area.owner is Player:
		var enemy_attack = Attack.new()
		enemy_attack.attack_damage = 10.0
		enemy_attack.knockback_force = 10.0
		enemy_attack.attack_position = global_position
		area.damage(enemy_attack)
		print("Get damaged")
	

func _physics_process(delta: float) -> void:
	pathfind()
