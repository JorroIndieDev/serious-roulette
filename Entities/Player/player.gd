class_name Player extends CharacterBody2D

## Maximum movement speed (pixels per second)
@export var base_max_speed := 200.0
var max_speed: float
## Acceleration rate (pixels per second per second)
@export var acceleration := 800.0
## Friction/deceleration when no input (pixels per second per second)
@export var friction := 1000.0
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
			equiped_gun._shoot()

#then record the you raise you mouse button
func _unhandled_input(_event) -> void:
	if not Input.is_action_just_pressed("attack"):
		input_attack = false

func _ready() -> void:
	
	max_speed = base_max_speed
	PlayerData.player_ref = self
	
	if gun_data:
		equiped_gun = gun_data.gun_scene.instantiate()
		equiped_gun.setup(gun_data)
		equiped_gun.gun_pivot = GunPivot
		GunAnchor.add_child(equiped_gun)


func _physics_process(delta: float) -> void:
	
	_movement(delta)
	
	_gun_movement()
	# Move the character
	move_and_slide()


func _movement(delta: float) -> void:
	# Get raw directional input (normalised vector)
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Desired velocity based on input
	var target_velocity := input_dir * max_speed
	
	# Apply acceleration or friction
	if input_dir:
		# Accelerate towards target velocity
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		# Decelerate with friction
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)


func _gun_movement() -> void:
	
	var mouse_direction := GunPivot.global_position.direction_to(get_global_mouse_position())
	GunAnchor.global_position = GunPivot.global_position + mouse_direction * gun_hold_distance
	equiped_gun.gun_sprite.flip_v = mouse_direction.x <= 0
	GunPivot.rotation = mouse_direction.angle()
	

func _recalculate_stats() -> void:
	
	for upgrade in PlayerData.upgrades_list:
		var u: PlayerUpgrade = upgrade as PlayerUpgrade
		
		max_speed += u.add_speed
		health_component.max_health += u.add_health
		# regen and the rest
	






#EOF
