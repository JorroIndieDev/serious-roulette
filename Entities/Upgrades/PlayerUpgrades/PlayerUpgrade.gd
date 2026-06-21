class_name PlayerUpgrade extends Upgrade

@export var add_speed: float
@export var add_health: float


func _stack_upgrade(u: Upgrade) -> Upgrade:
	
	if (u.max_stacks > 0 ) and (u.upgrade_stack <= u.max_stacks): return
	
	var other := u as PlayerUpgrade
	if not other:
		return self.duplicate()  # fallback

	# Create a brand new combined upgrade
	var combined := PlayerUpgrade.new()
	combined.id = self.id
	combined.name = self.name
	combined.texture = self.texture
	combined.max_stacks = self.max_stacks

	# Additive stacking (as you wanted)
	combined.add_speed = self.add_speed + other.add_speed
	combined.add_health = self.add_health + other.add_health

	# Important: sum the stack counts if you track them
	combined.upgrade_stack = self.upgrade_stack + other.upgrade_stack

	return combined

#func _apply_upgrade(object: Variant) -> void:
	
