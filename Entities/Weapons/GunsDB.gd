extends Node


var available_guns: Dictionary = {
	GunResource.ID.PISTOL: preload("uid://um2xjx88afcv"),
	GunResource.ID.HEAVYPISTOL: preload("uid://278g4rptvq6j"),
	GunResource.ID.FLINTLOCK: preload("uid://bn2r12evh5mn0"),
	GunResource.ID.RIFFLE: preload("uid://iuguev1b64bm"),
	GunResource.ID.CANNON: preload("uid://1n53q5b87psl"),
	GunResource.ID.ROCKETLAUNCHER: preload("uid://cl08tegiwtn6x"),
	GunResource.ID.SHOTGUN: preload("uid://bca5s574r1q2p"),
	GunResource.ID.STAFF: preload("uid://y8pt10hxo2fn")
}


func _populate_random(n: int) -> Array[GunResource]:
	
	var new_pool: Array[GunResource]
	var pick_array := available_guns.keys()
	
	for i in range(n):
		new_pool.append(available_guns[pick_array.pick_random()])
	
	return new_pool
