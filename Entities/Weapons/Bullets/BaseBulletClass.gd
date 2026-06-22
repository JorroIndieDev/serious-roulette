class_name BaseBullet extends Node2D

@export var hitbox: HitBoxComponent
@export var timer: Timer
@export var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D


var bullet_resource: BulletResource
var attack: Attack
var direction: Vector2

func _ready() -> void:
	if hitbox:
		hitbox.connect("area_entered", _on_hit)
	if visible_on_screen_notifier_2d:
		visible_on_screen_notifier_2d.connect("screen_exited", _screen_exited)
	if timer:
		timer.connect("timeout", self.queue_free)

func _process(delta: float) -> void:
	self.global_position += direction * bullet_resource.bullet_speed * delta

func _on_hit(area: Area2D) -> void:
	if area.owner is BaseBullet:
		return # The fix... 
	if area is HitBoxComponent:
		area.damage(attack)
	self.queue_free()

func _screen_exited() -> void:
	timer.start()
