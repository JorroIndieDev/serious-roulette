class_name Player extends CharacterBody2D

## Maximum movement speed (pixels per second)
@export var max_speed := 200.0
## Acceleration rate (pixels per second per second)
@export var acceleration := 800.0
## Friction/deceleration when no input (pixels per second per second)
@export var friction := 1000.0
@export var gun_hold_distance := 12
@onready var GunPivot: Marker2D = %GunPivot
@onready var GunAnchor: Node2D = $GunPivot/GunAnchor

<<<<<<< Updated upstream
@export var gun_data: GunResource
var equiped_gun: BaseGun

#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("attack"):
		#if gun:
			#gun._shoot()

func _ready() -> void:
	if gun_data:
		equiped_gun = gun_data.gun_scene.instantiate()
		GunAnchor.add_child(equiped_gun)
=======
@onready var pistol: Node2D = $GunPivot/GunAnchor/Pistol

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		pistol.shoot()

>>>>>>> Stashed changes

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
	GunAnchor.scale.y = 1 if mouse_direction.x > 0 else -1
	GunAnchor.rotation = mouse_direction.angle()
	
	
