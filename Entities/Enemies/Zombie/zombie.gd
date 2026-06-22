extends CharacterBody2D

@export var follow_k: float = 3.0
@export var max_speed: float = 150.0
@export var hitbox: HitBoxComponent
@export var value_points: int = 10
@export var value_coins: int = 5

@onready var sprite_2d: Sprite2D = $Sprite2D

var can_damage : bool = true

@export var texture_variants: Array[Texture2D]

func _ready() -> void:
	$HealthComponent.connect("damaged", _damaged)
	$HealthComponent.connect("died", _died)
	if hitbox:
		hitbox.connect("area_entered", melee)

func _physics_process(_delta: float) -> void:
	pathfind()


func _died() -> void:
	GameManager.spawn_coin(position, value_coins)
	PlayerData.player_points = value_points


func _damaged(dmg:float) -> void:
	flash_sprite(self.sprite_2d)
	$DamageNumberSpawner.spawn_label(dmg)


func pathfind():
	var distance = PlayerData.player_ref.global_position - global_position
	
	var raw_velocity = distance * follow_k
	
	velocity = raw_velocity.limit_length(max_speed)
	
	sprite_2d.flip_h = PlayerData.player_ref.global_position.x < global_position.x
	move_and_slide()


func melee(area: Area2D) -> void: 
	print("melee")
	if can_damage and area is HitBoxComponent and area.owner is Player:
		var enemy_attack = Attack.new()
		enemy_attack.attack_damage = 10.0
		enemy_attack.knockback_force = 10.0
		enemy_attack.attack_position = global_position
		area.damage(enemy_attack)
		print("Get damaged")
		can_damage = false
		hitbox.set_deferred("monitorable", can_damage)
		hitbox.set_deferred("monitoring", can_damage)
		await get_tree().create_timer(1.0).timeout
		can_damage = true
		hitbox.set_deferred("monitorable", can_damage)
		hitbox.set_deferred("monitoring", can_damage)


func flash_sprite(sprite: Sprite2D) -> void:
	var mat = sprite.material as ShaderMaterial
	if not mat:
		return

	# Store original values (flash is 0, brightness is 1)
	var _orig_flash = mat.get_shader_parameter("flash")
	var _orig_brightness = mat.get_shader_parameter("brightness")

	var tween = create_tween()
	tween.set_parallel(true)   # run both animations at the same time

	# Flash: 0 → 1 → 0
	tween.tween_method(
		func(value): mat.set_shader_parameter("flash", value),
		0.0, 1.0, 0.05
	)
	tween.tween_method(
		func(value): mat.set_shader_parameter("flash", value),
		1.0, 0.0, 0.1
	)

	# Brightness: 1 → 3 → 1  (boost for glow)
	tween.tween_method(
		func(value): mat.set_shader_parameter("brightness", value),
		1.0, 3.0, 0.05
	)
	tween.tween_method(
		func(value): mat.set_shader_parameter("brightness", value),
		3.0, 1.0, 0.1
	)
