extends BaseGun

func _shoot() -> void:

	var bullet_data := _apply_bullet_modifiers(gun_data.loaded_bullet)
	
	var bullet: BaseBullet = bullet_data.bullet_scene.instantiate()
	bullet.bullet_resource = bullet_data
	bullet.attack = _calculate_attack(bullet_data)
	GameManager.ProjectileContainer.call_deferred("add_child", bullet)
	bullet.position = %Muzzle.global_position
	
	print("Shot")
