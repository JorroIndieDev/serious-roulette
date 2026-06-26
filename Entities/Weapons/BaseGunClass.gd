class_name BaseGun extends Node2D

@export var gun_sprite: AnimatedSprite2D
#@export var gun_sprite_animated: AnimatedSprite2D
@export var shooting_particle: CPUParticles2D
@export var muzzle: Marker2D
var gun_pivot: Marker2D
var gun_data: GunResource

var _shot_timer: Timer
var _reload_timer: Timer
var _is_reloading: bool = false  
#var gun_sprite

func _ready() -> void:
	gun_sprite.play("normal")
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
	play_sound(gun_data.reload_sound)
	# Optionally play reload animation/sound
	return true

# Override try_shoot to respect reload state and ammo
func try_shoot() -> bool:
	# Can't shoot if reloading or ammo empty
	if _is_reloading:
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
	if gun_data == null or gun_data.current_ammo <= 0:
		try_reload()
	return true

func _shoot() -> void:
	var bullet_data := _apply_bullet_modifiers(gun_data.loaded_bullet)
	var bullet: BaseBullet = bullet_data.bullet_scene.instantiate()
	if "isRocket" in bullet:
		bullet.isRocket = gun_data.is_rocket
	bullet.bullet_resource = bullet_data
	bullet.attack = _calculate_attack(bullet_data)

	# Base direction from gun pivot to mouse
	var base_dir := gun_pivot.global_position.direction_to(get_global_mouse_position())
	
	shooting_particle.scale.x = -1 if global_position.x > get_global_mouse_position().x else 1
	
	shooting_particle.emitting = true
	
	# Spread (static version)
	var spread_rad := deg_to_rad(gun_data.spread_degrees)
	var offset := randf_range(-spread_rad, spread_rad)
	bullet.direction = base_dir.rotated(offset)

	bullet.position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation

	GameManager.ProjectileContainer.call_deferred("add_child", bullet)

	# Visual recoil (your existing method)
	_apply_recoil()

	play_sound(gun_data.shot_sound)
	
	bullet.direction = gun_pivot.global_position.direction_to(get_global_mouse_position())
	bullet.position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation
	
func play_sound(stream: AudioStream) -> void:
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
	attack.knockback_force = b_data.knock_back_force # knockback should be defined as bullet variables
	
	return attack

func _apply_bullet_modifiers(b_data: BulletResource) -> BulletResource:
	var new_data: BulletResource = b_data.duplicate()
	new_data.bullet_speed = b_data.base_speed
	return new_data

func _apply_recoil() -> void:
	var tween := create_tween()

	var start_pos := position
	var start_rot := rotation

	var recoil_pos := Vector2(-gun_data.recoil_distance_pixels, 0.0)
	var recoil_angle := deg_to_rad(-gun_data.recoil_angle_degrees)

	if global_position.x > get_global_mouse_position().x:
		recoil_angle = -recoil_angle

	# Kick
	tween.tween_property(gun_sprite, "position", start_pos + recoil_pos, gun_data.recoil_duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(gun_sprite, "rotation", start_rot + recoil_angle, gun_data.recoil_duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)

	# Return
	tween.tween_property(gun_sprite, "position", start_pos, gun_data.return_duration)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	tween.parallel().tween_property(gun_sprite, "rotation", start_rot, gun_data.return_duration)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)

#EOF
