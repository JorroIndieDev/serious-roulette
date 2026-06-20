class_name BaseGun extends Node2D

var gun_data: GunResource

func _shoot() -> void:
	assert(false, "Abstract class")
	return

func setup(data: GunResource) -> void:
	gun_data = data

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
	var new_data: BulletResource = b_data
	new_data.bullet_speed = b_data.base_speed
	return new_data
