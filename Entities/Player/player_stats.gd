class_name PlayerStats extends Node

## Maximum movement speed (pixels per second)
@export var base_max_speed := 200.0
var max_speed: float
## Acceleration rate (pixels per second per second)
@export var acceleration := 800.0
## Friction/deceleration when no input (pixels per second per second)
@export var friction := 1000.0

func _ready() -> void:
	pass
