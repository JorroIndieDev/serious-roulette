extends Node

var player_ref: Player
var upgrades_list: Array[Upgrade] = []

func _append_upgrade(upgrade:Upgrade) -> void:
	
	if upgrades_list.is_empty():
		upgrades_list.append(upgrade)
		player_ref._recalculate_stats()
	
	var stack := false
	
	for u in upgrades_list:
		if upgrade == u:
			u._stack_upgrade(upgrade)
			stack = true
		break
	
	if !stack:
		upgrades_list.append(upgrade)
	
