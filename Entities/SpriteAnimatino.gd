extends Sprite2D

# Sway parameters
@export var idle_amplitude: float = 0.02    # radians (≈1.15°)
@export var walk_amplitude: float = 0.12    # radians (≈6.9°)
@export var sway_speed: float = 4.0         # cycles per second

var sway_time: float = 0.0

# Reference to the parent (your CharacterBody2D)
@onready var parent: CharacterBody2D = get_parent()
var current_amplitude: float = 0.0

func _process(delta: float) -> void:
	sway_time += delta

	var is_moving = parent.velocity.length() > 10.0
	var target_amp = walk_amplitude if is_moving else idle_amplitude

	# Smoothly interpolate current amplitude towards target
	current_amplitude = lerp(current_amplitude, target_amp, 8.0 * delta)

	rotation = sin(sway_time * sway_speed) * current_amplitude
