class_name BasicBullet extends Node2D

@export var bullet_resource: BulletResource
var direction: Vector2 
var attack: Attack

func _ready() -> void:
	bullet_resource.bullet_speed = bullet_resource.base_speed


func _process(delta: float) -> void:
	self.position += self.transform.x * bullet_resource.bullet_speed * delta
