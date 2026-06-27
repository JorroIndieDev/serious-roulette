extends Node


var available_upgrades: Dictionary = {
	Upgrade.ID.MOVESPEED: preload("uid://b0q2hx5ddp5of"),
	Upgrade.ID.GUNDMGUP: preload("uid://c36vp1ar3qart"),
	Upgrade.ID.BULLETDMGUP: preload("uid://bx7b7xcpepcgj"),
	#Upgrade.ID.PIERCE: preload("uid://bweh25fdi8a7j"),
	#Upgrade.ID.BULLETSPD: preload("uid://lur57acqq6uq"),
	#Upgrade.ID.FIRERATE: preload("uid://cxjeehg7ihaev"),
	#Upgrade.ID.INFINITEBULLETS: preload("uid://b1wiw4sqcrfyf"),
	#Upgrade.ID.HEAL: preload("uid://cdxdkuinufdal")
}


func _populate_random(n: int) -> Array[Upgrade]:
	
	var new_pool: Array[Upgrade]
	var pick_array := available_upgrades.keys()
	
	for i in range(n):
		new_pool.append(available_upgrades[pick_array.pick_random()])
	
	return new_pool
