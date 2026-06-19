class_name Player extends CharacterBody2D

## Maximum movement speed (pixels per second)
@export var max_speed := 200.0
## Acceleration rate (pixels per second per second)
@export var acceleration := 800.0
## Friction/deceleration when no input (pixels per second per second)
@export var friction := 1000.0


func _physics_process(delta: float) -> void:
	
	_movement(delta)
	
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
	return
