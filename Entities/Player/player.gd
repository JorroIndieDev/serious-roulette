class_name Player extends CharacterBody2D

@export var stats: PlayerStats

@export var gun_hold_distance := 12

@onready var health_component: HealthComponent = $HealthComponent

@onready var GunPivot: Marker2D = %GunPivot
@onready var GunAnchor: Node2D = $GunPivot/GunAnchor

@export var gun_data: GunResource
var equiped_gun: BaseGun
var input_attack: bool = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack") and not input_attack:
		if equiped_gun:
			input_attack = true
			equiped_gun.try_shoot()

#then record the you raise you mouse button
func _unhandled_input(_event) -> void:
	if not Input.is_action_just_pressed("attack"):
		input_attack = false

func _damaged(dmg: float) -> void:
	$DamageNumberSpawner.spawn_label(dmg)

func _ready() -> void:
	
	stats.max_speed = stats.base_max_speed
	PlayerData.player_ref = self
	
	health_component.connect("damaged", _damaged)
	
	if gun_data:
		PlayerData._change_gun(gun_data)


func _physics_process(delta: float) -> void:
	
	_movement(delta)
	
	_gun_movement()
	# Move the character
	move_and_slide()


func _movement(delta: float) -> void:
	# Get raw directional input (normalised vector)
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Desired velocity based on input
	var target_velocity := input_dir * stats.max_speed
	
	# Apply acceleration or friction
	if input_dir:
		# Accelerate towards target velocity
		velocity = velocity.move_toward(target_velocity, stats.acceleration * delta)
	else:
		# Decelerate with friction
		velocity = velocity.move_toward(Vector2.ZERO, stats.friction * delta)


func _gun_movement() -> void:
	
	var mouse_direction := GunPivot.global_position.direction_to(get_global_mouse_position())
	GunAnchor.global_position = GunPivot.global_position + mouse_direction * gun_hold_distance
	equiped_gun.gun_sprite.flip_v = mouse_direction.x <= 0
	GunPivot.rotation = mouse_direction.angle()
	

func _recalculate_stats(upgrade: Upgrade) -> void:
	
	var u: PlayerUpgrade = upgrade as PlayerUpgrade
	
	stats.max_speed += u.add_speed
	health_component.max_health += u.add_health
	# regen and the rest








#EOF
