class_name PlayerUpgrade extends Upgrade

@export var add_speed: float
@export var add_health: float


func _stack_upgrade(_u: Upgrade) -> void:
	
	if _u.max_stacks != 0 and (_u.upgrade_stack >= _u.max_stacks): return
	
	var u := _u as PlayerUpgrade
	add_health += u.add_health
	add_speed += u.add_speed
	
	#regen and what not goes here
	
	upgrade_stack += 1
