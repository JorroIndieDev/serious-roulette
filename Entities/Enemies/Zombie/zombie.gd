extends CharacterBody2D

@export var follow_k: float = 3.0
@export var max_speed: float = 150.0
@export var hitbox: HitBoxComponent
@export var value_points: int = 10
@export var value_coins: int = 5

@export var attack: Attack

@onready var sprite_2d: Sprite2D = $Sprite2D

var knockback: Vector2 = Vector2.ZERO
## units per second
@export var knockback_decay: float = 5.0

var can_damage : bool = true

@export var texture_variants: Array[Texture2D]

func _ready() -> void:
	$HealthComponent.connect("damaged", _damaged)
	$HealthComponent.connect("died", _died)
	if hitbox:
		hitbox.connect("area_entered", melee)

func _physics_process(_delta: float) -> void:
	pathfind(_delta)


func _died() -> void:
	GameManager.spawn_coin(position, value_coins)
	PlayerData.player_points = value_points


func _damaged(_attack: Attack) -> void:
	flash_sprite(sprite_2d)
	apply_knockback(-position.direction_to(_attack.attack_position), _attack.knockback_force)
	$DamageNumberSpawner.spawn_label(_attack.attack_damage)


func pathfind(delta: float):
	var distance = PlayerData.player_ref.global_position - global_position
	
	var raw_velocity = distance * follow_k
	
	velocity = raw_velocity.limit_length(max_speed)
	
	sprite_2d.flip_h = PlayerData.player_ref.global_position.x < global_position.x
	velocity += knockback
	move_and_slide()
	knockback = knockback.lerp(Vector2.ZERO, 1.0 - exp(-knockback_decay * delta))


func melee(area: Area2D) -> void: 
	if area.owner is BaseBullet: return
	if can_damage and area is HitBoxComponent:
		var enemy_attack = Attack.new()
		enemy_attack.attack_damage = attack.attack_damage
		enemy_attack.knockback_force = attack.knockback_force
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

func apply_knockback(direction: Vector2, strength: float) -> void:
	knockback = direction.normalized() * strength

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
