class_name BasicBullet extends Node2D

@export var hitbox: HitBoxComponent
var bullet_resource: BulletResource
var attack: Attack
var direction: Vector2

func _ready() -> void:
	hitbox.connect("area_entered", _on_hit)

func _process(delta: float) -> void:
	self.global_position += direction * bullet_resource.bullet_speed * delta

func _on_hit(area: Area2D) -> void:
	if area.owner is BasicBullet:
		return # The fix... 
	if area is HitBoxComponent:
		area.damage(attack)
	self.queue_free()
