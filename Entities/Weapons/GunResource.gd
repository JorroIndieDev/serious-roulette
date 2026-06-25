class_name GunResource extends Resource

@export_category("Base stats")
## Base damage to be multiplied or added to a bullet damage
@export var base_damage: float
## Bullets per second
@export var fire_rate: int
## How many bullets can fire before reloading
@export var base_ammo: int
## How many bullets left to fire
var current_ammo: int
@export var reload_time: float

## Strength of the "Kick" on the camera shake
@export_range(0.5, 5.0, 0.1) var gun_strength: float = 0.5

@export_category("Recoil")
@export var recoil_angle_degrees: float = 5.0      # upward tilt (positive = clockwise, negative = counter‑clockwise)
@export var recoil_distance_pixels: float = 10.0   # how far the gun kicks back
@export var recoil_duration: float = 0.08          # time to reach maximum recoil
@export var return_duration: float = 0.15          # time to return to rest

@export_category("Bullet Spread")
@export var max_spread_degrees: float = 10.0
@export var spread_increment: float = 1.0    # degrees added per shot
@export var spread_decay: float = 5.0        # degrees per second
@export var spread_degrees: float = 2.0   # cone width in degrees

@export_category("Extra resources")
## Bullet Resource that the gun will fire
@export var loaded_bullet: BulletResource

## Sound of the gun
@export var shot_sound: AudioStream

## Sound of reload
@export var reload_sound: AudioStream

## Is a rocket?
@export var is_rocket: bool

## Gun scene
@export var gun_scene: PackedScene
