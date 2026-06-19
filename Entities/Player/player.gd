class_name Player extends CharacterBody2D

## Maximum movement speed (pixels per second)
@export var max_speed := 200.0
## Acceleration rate (pixels per second per second)
@export var acceleration := 800.0
## Friction/deceleration when no input (pixels per second per second)
@export var friction := 1000.0
@export var gun_hold_distance := 25

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

@onready var GunPivot: Marker2D = $GunAnchor
@onready var icon: Sprite2D = $GunAnchor/Icon

func _gun_movement() -> void:
	
	var mouse_direction := GunPivot.global_position.direction_to(get_global_mouse_position())
	icon.global_position = GunPivot.global_position + mouse_direction * gun_hold_distance
	icon.flip_v = mouse_direction.x < 0
	icon.look_at(get_global_mouse_position())
	
	
