class_name GunUpgrade extends Upgrade

@export var inc_base_damage: float

@export var inc_fire_rate: int

@export var inc_base_ammo: int

@export var infinite_ammo: bool

@export var temp_timer: float


# GunUpgrade.gd
func _stack_upgrade(u: Upgrade) -> Upgrade:
	var other := u as GunUpgrade
	if not other:
		return self.duplicate()  # fallback

	# Create a brand new combined upgrade
	var combined := GunUpgrade.new()
	combined.id = self.id
	combined.name = self.name
	combined.texture = self.texture
	combined.max_stacks = self.max_stacks

	# Additive stacking (as you wanted)
	combined.inc_base_damage = self.inc_base_damage + other.inc_base_damage
	combined.inc_fire_rate = self.inc_fire_rate + other.inc_fire_rate
	combined.inc_base_ammo = self.inc_base_ammo + other.inc_base_ammo

	# Important: sum the stack counts if you track them
	combined.upgrade_stack = self.upgrade_stack + other.upgrade_stack

	return combined

func _apply_upgrade(object: Variant) -> void:
	if !(object is GunResource): return
	
	var gun: GunResource = object as GunResource
	
	print_debug("
	Gun damage: "+str(gun.base_damage)+"\n
	Gun upgrade: "+str(inc_base_damage)+"\n 
	dmg+upgrade: "+str(gun.base_damage+inc_base_damage))
	
	
	gun.base_damage += inc_base_damage
	gun.fire_rate += inc_fire_rate
	gun.base_ammo += inc_base_ammo
	
	# infinite ammo goes here






#EOF
