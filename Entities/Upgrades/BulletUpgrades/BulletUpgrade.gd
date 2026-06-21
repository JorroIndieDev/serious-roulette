class_name BulletUpgrade extends Upgrade

@export var inc_pierce: int

@export var inc_damage: float

@export var inc_speed: float


func _stack_upgrade(u: Upgrade) -> Upgrade:
	var other := u as BulletUpgrade
	if not other:
		return self.duplicate()  # fallback

	# Create a brand new combined upgrade
	var combined := BulletUpgrade.new()
	combined.id = self.id
	combined.name = self.name
	combined.texture = self.texture
	combined.max_stacks = self.max_stacks

	# Additive stacking (as you wanted)
	combined.inc_pierce = self.inc_pierce + other.inc_pierce
	combined.inc_damage = self.inc_damage + other.inc_damage
	combined.inc_speed = self.inc_speed + other.inc_speed

	# Important: sum the stack counts if you track them
	combined.upgrade_stack = self.upgrade_stack + other.upgrade_stack

	return combined

func _apply_upgrade(object: Variant) -> void:
	if !(object is BulletResource): return
	
	var bullet: BulletResource = object as BulletResource
	
	print_debug("
	bullet damage: "+str(bullet.bullet_damage)+"\n
	bullet upgrade: "+str(inc_damage)+"\n 
	dmg+upgrade: "+str(bullet.bullet_damage+inc_damage))
	
	
	bullet.bullet_damage += inc_damage
	bullet.base_speed += inc_speed
	bullet.max_pierce += inc_pierce
	
	# infinite ammo goes here
