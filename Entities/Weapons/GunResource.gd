class_name GunResource extends Resource

## Base damage to be multiplied or added to a bullet damage
@export var base_damage: float

## Bullets per second
@export var fire_rate: int

## How many bullets can fire before reloading
@export var base_ammo: int
## How many bullets left to fire
var current_ammo: int
@export var reload_time: float

## Bullet Resource that the gun will fire
@export var loaded_bullet: BulletResource

## Sound of the gun
@export var shot_sound: AudioStream

## Gun scene
@export var gun_scene: PackedScene
