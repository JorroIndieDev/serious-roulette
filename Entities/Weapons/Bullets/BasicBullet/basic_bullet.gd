class_name BasicBullet extends Node2D

var bullet_resource: BulletResource
var attack: Attack

func _process(delta: float) -> void:
	self.position += self.transform.x * bullet_resource.bullet_speed * delta
