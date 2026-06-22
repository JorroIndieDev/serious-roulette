class_name BaseGun extends Node2D

@export var gun_sprite: Sprite2D
var gun_pivot: Marker2D
var gun_data: GunResource

var _shot_timer: Timer
var _reload_timer: Timer
var _is_reloading: bool = false  
var _shoot_audio_player: AudioStreamPlayer2D

func _ready() -> void:
	# Create the timer node
	_shot_timer = Timer.new()
	_shot_timer.one_shot = true          # auto-stop after firing
	add_child(_shot_timer)               # add as child so it processes automatically
	# Setup reload timer
	_reload_timer = Timer.new()
	_reload_timer.one_shot = true
	_reload_timer.timeout.connect(_on_reload_finished)   # connect signal
	add_child(_reload_timer)
	
func setup(data: GunResource) -> void:
	gun_data = data
	if gun_data:
		gun_data.current_ammo = gun_data.base_ammo

func _get_fire_delay() -> float:
	return 1.0 / gun_data.fire_rate if gun_data else 0.0

# NEW: Get reload time from gun_data
func _get_reload_time() -> float:
	return gun_data.reload_time if gun_data else 0.0

# Called when reload timer finishes
func _on_reload_finished() -> void:
	if gun_data:
		gun_data.current_ammo = gun_data.base_ammo
	_is_reloading = false
	# Optionally emit a signal or update UI

# Start reloading
func try_reload() -> bool:
	if not gun_data:
		return false
	if _is_reloading:
		return false   # already reloading
	if gun_data.current_ammo >= gun_data.base_ammo:
		return false   # already full
	#if gun_data.reserve_ammo <= 0:
		#return false   # no spare ammo

	_is_reloading = true
	_reload_timer.wait_time = _get_reload_time()
	_reload_timer.start()
	# Optionally play reload animation/sound
	return true

# Override try_shoot to respect reload state and ammo
func try_shoot() -> bool:
	# Can't shoot if reloading or ammo empty
	if _is_reloading:
		return false
	if gun_data == null or gun_data.current_ammo <= 0:
		# Auto‑reload when empty (optional)
		try_reload()
		return false

	# Cooldown check
	if _shot_timer.time_left > 0.0:
		return false

	# Consume ammo
	gun_data.current_ammo -= 1

	# Start shot cooldown
	_shot_timer.wait_time = _get_fire_delay()
	_shot_timer.start()

	# Perform the actual shooting (implemented in child)
	_shoot()
	return true

func _shoot() -> void:
	var bullet_data := _apply_bullet_modifiers(gun_data.loaded_bullet)
	var bullet: BaseBullet = bullet_data.bullet_scene.instantiate()
	
	bullet.bullet_resource = bullet_data
	bullet.attack = _calculate_attack(bullet_data)
	
	play_shoot_sound(gun_data.shot_sound)
	
	GameManager.ProjectileContainer.call_deferred("add_child", bullet)
	bullet.direction = gun_pivot.global_position.direction_to(get_global_mouse_position())
	bullet.position = %Muzzle.global_position
	bullet.rotation = %Muzzle.global_rotation
	
func play_shoot_sound(stream: AudioStream) -> void:
	if not stream:
		return
	
	var temp_player := AudioStreamPlayer2D.new()
	temp_player.stream = stream
	temp_player.pitch_scale = randf_range(0.9, 1.1)
	temp_player.global_position = global_position
	temp_player.volume_linear = 0.3
	
	temp_player.finished.connect(temp_player.queue_free)
	get_tree().current_scene.add_child(temp_player)
	temp_player.play()

func _calculate_attack(b_data: BulletResource) -> Attack:
	
	var attack := Attack.new()
	
	var new_damage := 0.0
	if b_data.multiplicative: new_damage = gun_data.base_damage * b_data.bullet_damage
	else: new_damage = gun_data.base_damage + b_data.bullet_damage
	
	attack.attack_damage = new_damage
	attack.attack_position = self.global_position
	attack.knockback_force = 0 # knockback should be defined as bullet variables
	
	return attack

func _apply_bullet_modifiers(b_data: BulletResource) -> BulletResource:
	var new_data: BulletResource = b_data.duplicate()
	new_data.bullet_speed = b_data.base_speed
	return new_data
