extends Node

var player_ref: Player

var upgrades_list: Array[Upgrade] = []

signal _player_leveled

var leveled_up: bool:
	get: return leveled_up
	set(value):
		leveled_up = value
		if value: emit_signal("_player_leveled")

func _ready() -> void:
	connect("_player_leveled", GameManager._player_leveled)

func _change_gun(gun: GunResource) -> void:
	if !player_ref.gun_data:
		player_ref.gun_data = gun
		return
	
	if !gun.loaded_bullet:
		gun.loaded_bullet = player_ref.gun_data.loaded_bullet
	
	player_ref.gun_data = gun
	
	player_ref.equiped_gun = gun.gun_scene.instantiate()
	player_ref.equiped_gun.setup(gun)
	player_ref.equiped_gun.gun_pivot = player_ref.GunPivot
	player_ref.GunAnchor.add_child(player_ref.equiped_gun)

func _append_upgrade(upgrade: Upgrade) -> void:
	# 1. Duplicate the DB resource immediately so we don't mutate the original.
	var new_upgrade: Upgrade = upgrade.duplicate()
	var replaced := false

	# 2. Search for existing upgrade by ID
	for i in range(upgrades_list.size()):
		
		var existing: Upgrade = upgrades_list[i]
		
		if existing.id == new_upgrade.id:
			# 3. Combine them (this should return a NEW combined Upgrade instance)
			var combined: Upgrade = existing._stack_upgrade(new_upgrade)
			# 4. Replace the old one in the array with the combined one
			upgrades_list[i] = combined
			replaced = true
			break

	# 5. If no match was found, append the duplicated new upgrade
	if not replaced:
		upgrades_list.append(new_upgrade)
		
	# 6. Recalculate all stats from scratch (safest approach)
	match new_upgrade:
		var pu when pu is PlayerUpgrade:
			player_ref._recalculate_stats(new_upgrade)
			
		var gu when gu is GunUpgrade:
			gu._apply_upgrade(player_ref.gun_data)
		
		var bu when bu is BulletUpgrade:
			bu._apply_upgrade(player_ref.gun_data.loaded_bullet)
		
		_:
			pass
	print(upgrade.name)
