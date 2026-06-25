extends Node


var available_guns: Dictionary = {
	GunResource.ID.PISTOL: preload("uid://um2xjx88afcv"),
	#GunResource.ID.HEAVYPISTOL: preload("uid://278g4rptvq6j")
}


func _populate_random(n: int) -> Array[GunResource]:
	
	var new_pool: Array[GunResource]
	var pick_array := available_guns.keys()
	
	for i in range(n):
		new_pool.append(available_guns[pick_array.pick_random()])
	
	return new_pool
