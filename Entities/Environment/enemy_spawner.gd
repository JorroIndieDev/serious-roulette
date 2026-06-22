extends Node2D

@export var enemy_scene : PackedScene
var player: Player
@export var spawn_radius: float = 600.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$spawnTimer.timeout.connect(_on_spawn_timer_timeout)
	player = PlayerData.player_ref
	
func _on_spawn_timer_timeout() -> void: 
	if player == null:
		return
		
	var enemy = enemy_scene.instantiate()

	var random_angle = randf() * TAU

	var direction = Vector2.RIGHT.rotated(random_angle)
	var spawn_pos = player.global_position + (direction * spawn_radius)
	
	enemy.global_position = spawn_pos
	add_child(enemy)
