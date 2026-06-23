class_name Player extends CharacterBody2D

@export var stats: PlayerStats

@export var gun_hold_distance := 12
## units per second
@export var knockback_decay: float = 5.0

@onready var health_component: HealthComponent = $HealthComponent

@onready var GunPivot: Marker2D = %GunPivot
@onready var GunAnchor: Node2D = $GunPivot/GunAnchor
@onready var camera: PlayerCamera = $Camera2D
@onready var character_sprite: Sprite2D = $Sprite2D

@export var gun_data: GunResource

var equiped_gun: BaseGun
var input_attack: bool = false

var knockback: Vector2 = Vector2.ZERO

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and not input_attack:
		if equiped_gun:
			input_attack = true
			if equiped_gun.try_shoot(): 
				camera.shake(0.5, gun_data.gun_strength)

func _unhandled_input(_event) -> void:
	if not Input.is_action_just_pressed("attack"):
		input_attack = false

func _damaged(attack: Attack) -> void:
	camera.shake(.5,1.0)
	apply_knockback(-position.direction_to(attack.attack_position), attack.knockback_force)
	flash_sprite(character_sprite)
	$DamageNumberSpawner.spawn_label(attack.attack_damage)

func died() -> void:
	PlayerData.emit_signal("player_died")

func _ready() -> void:
	
	stats.max_speed = stats.base_max_speed
	PlayerData.player_ref = self
	
	health_component.connect("damaged", _damaged)
	
	if gun_data:
		PlayerData._change_gun(gun_data)

func _physics_process(delta: float) -> void:
	
	_movement(delta)
	
	_gun_movement()
	
	# Move the character
	velocity += knockback
	move_and_slide()
	knockback = knockback.lerp(Vector2.ZERO, 1.0 - exp(-knockback_decay * delta))

func _movement(delta: float) -> void:
	
	# Get raw directional input (normalised vector)
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	$Sprite2D.flip_h = sign(position.direction_to(get_global_mouse_position()).x) < 0 
	# Desired velocity based on input
	var target_velocity := input_dir * stats.max_speed

	# Apply acceleration or friction
	if input_dir:
		# Accelerate towards target velocity
		velocity = velocity.move_toward(target_velocity, stats.acceleration * delta)
	else:
		# Decelerate with friction
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)

func _gun_movement() -> void:
	var mouse_direction := GunPivot.global_position.direction_to(get_global_mouse_position())
	GunAnchor.global_position = GunPivot.global_position + mouse_direction * gun_hold_distance
	if mouse_direction.x <= 0:
		equiped_gun.gun_sprite.flip_v = true
		equiped_gun.muzzle.position.y = abs(equiped_gun.muzzle.position.y)
		equiped_gun.shooting_particle.position.x = abs(equiped_gun.shooting_particle.position.x)
		equiped_gun.muzzle.rotation = PI
	else:
		equiped_gun.gun_sprite.flip_v = false
		equiped_gun.muzzle.position.y = -abs(equiped_gun.muzzle.position.y)
		equiped_gun.shooting_particle.position.x = -abs(equiped_gun.shooting_particle.position.x)
		equiped_gun.muzzle.rotation = 0
	
	GunPivot.rotation = mouse_direction.angle()

func apply_knockback(direction: Vector2, strength: float) -> void:
	knockback = direction.normalized() * strength

func _recalculate_stats(upgrade: Upgrade) -> void:
	
	var u: PlayerUpgrade = upgrade as PlayerUpgrade
	
	stats.max_speed += u.add_speed
	health_component.max_health += u.add_health
	# regen and the rest

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

#EOF
