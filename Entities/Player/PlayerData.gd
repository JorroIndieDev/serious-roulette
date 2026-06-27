extends Node

var player_ref: Player

var level_up_step: int = 0
var level_up_milestone: int = 100

var leveled_up: bool:
	get: return leveled_up
	set(value):
		leveled_up = value
		if value: emit_signal("_player_leveled")

var _player_points: int = 0
var player_points: int:
	set(value): 
		_player_points += value
		var temp = _player_points / level_up_milestone
		if temp > level_up_step:
			level_up_step = temp
			leveled_up = true
		emit_signal("points_gained", _player_points)
		#print_debug(_player_points)
	get: return _player_points

var _player_coins: int = 0
var player_coins: int:
	set(value): 
		_player_coins += value
		emit_signal("coins_gained", _player_coins)
		#print_debug(_player_coins)
	get: return _player_coins


var upgrades_list: Array[Upgrade] = []

signal points_gained(ammount: int)
signal coins_gained(ammount: int)

signal _player_leveled


func _ready() -> void:
	connect("_player_leveled", GameManager._player_leveled)
	connect("points_gained", GameManager._update_hud_points)
	connect("coins_gained", GameManager._update_hud_coins)

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
	var _g
	if player_ref.GunAnchor.get_children().size() >= 1:
		_g = player_ref.GunAnchor.get_child(0)
		player_ref.GunAnchor.remove_child(_g)
	player_ref.GunAnchor.call_deferred("add_child", player_ref.equiped_gun)

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

#func player_died() -> void:
	#pass

func _player_died() -> void:
	GameManager.player_score = player_points
	GameManager.player_died()

func _respawn_player() -> void:
	# Kill all enemies, by deleting them
	# "Spawn" player
	player_ref.health_component.reset()
	player_ref._immunity()


func reset_data() -> void:
	upgrades_list = []
	level_up_step = 0
	leveled_up = false
	_player_points = 0
	_player_coins = 0
	pass


#EOF
