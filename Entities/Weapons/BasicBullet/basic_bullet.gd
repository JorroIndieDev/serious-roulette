class_name BasicBullet extends Node2D

var direction: Vector2 
var speed: float = 0.0
var attack: Attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	#rotation = transform.x.angle()
