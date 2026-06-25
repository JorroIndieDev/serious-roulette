extends BaseGun

@export var bullet_amount: int

func _shoot() -> void:
	var base_dir := gun_pivot.global_position.direction_to(get_global_mouse_position())
	
	shooting_particle.scale.x = -1 if global_position.x > get_global_mouse_position().x else 1
	shooting_particle.emitting = true
	_apply_recoil()
	
	if gun_data.shot_sound:
		play_sound(gun_data.shot_sound)
	
	for i in bullet_amount:
		
		var bullet_data := _apply_bullet_modifiers(gun_data.loaded_bullet)
		var bullet: BaseBullet = bullet_data.bullet_scene.instantiate()
		bullet.bullet_resource = bullet_data
		bullet.attack = _calculate_attack(bullet_data)
		
		var spread_rad := deg_to_rad(gun_data.spread_degrees)
		
		var offset := randf_range(-spread_rad, spread_rad)
		var final_direction = base_dir.rotated(offset)
		
		bullet.direction = final_direction
		bullet.position = %Muzzle.global_position

		bullet.rotation = final_direction.angle()

		GameManager.ProjectileContainer.call_deferred("add_child", bullet)
