extends Node


var available_upgrades: Dictionary = {
	Upgrade.ID.MOVESPEED: preload("uid://b0q2hx5ddp5of"),
	Upgrade.ID.GUNDMGUP: preload("uid://c36vp1ar3qart"),
	Upgrade.ID.BULLETDMGUP: preload("uid://bx7b7xcpepcgj"),
}


func _populate_random(n: int) -> Array[Upgrade]:
	
	var new_pool: Array[Upgrade]
	var pick_array := available_upgrades.keys()
	
	for i in range(n):
		new_pool.append(available_upgrades[pick_array.pick_random()])
	
	return new_pool
