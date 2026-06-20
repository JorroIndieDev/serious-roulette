class_name BasicBullet extends Node2D

@export var hitbox: HitBoxComponent
var bullet_resource: BulletResource
var attack: Attack

func _ready() -> void:
	hitbox.connect("area_entered", _on_hit)

func _process(delta: float) -> void:
	self.position += self.transform.x * bullet_resource.bullet_speed * delta

func _on_hit(area) -> void:
	if area is HitBoxComponent:
		area.damage(attack)
	self.queue_free()
