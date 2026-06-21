extends Node2D

signal prize_won(reward: Upgrade)

@export var num_prizes: int = 8
@export var spins: int = 5
@export var spin_duration: int = 4
@onready var background: Sprite2D = $Background

@export var height_to_slide: float = 400
@export var time_to_slide: float = 0.5
@export var display_duration: float = 1.5

@export var prize_pool: Array[Upgrade]
@onready var prize: Control = $"../Prize"

@export var gambling_node: GamblingNode

var offscreen_y: float
var onscreen_y: float
var winning_prize: Upgrade
#var winning_texture: Texture2D

func _ready() -> void:
	
	connect("prize_won", PlayerData._append_upgrade)
	
	offscreen_y = position.y
	onscreen_y = offscreen_y - height_to_slide
	position.x = get_viewport_rect().size.x/2
	

func spin():
	var icons_container = $Background/PrizeContainer
	
	prize_pool = UpgradeDB._populate_random(num_prizes)
	
	for i in range(num_prizes):
		var prize_sprite = icons_container.get_child(i) as Sprite2D
		prize_sprite.texture = prize_pool[i].texture
		
	var winning_index = randi() % num_prizes
	
	winning_prize = prize_pool[winning_index]
	
	background.rotation = 0.0
	
	var slice_angle = TAU / num_prizes 
	
	var target_offset = TAU - (winning_index * slice_angle)
	if winning_index == 0:
		target_offset = 0.0
		
	var distance_to_target = target_offset - rotation
	if distance_to_target < 0:
		distance_to_target = 0.0
	
	var target_angle = rotation + (spins * TAU) + distance_to_target - slice_angle/2
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", onscreen_y, time_to_slide).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(background, "rotation", target_angle, spin_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	prize_won.emit(winning_prize)
	gambling_node.show_prize(winning_prize.texture, winning_prize.name, winning_prize.description)
	await get_tree().create_timer(display_duration).timeout
	
	
	var tween_out = create_tween()
	tween_out.tween_property(self, "position:y", offscreen_y, time_to_slide).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	background.rotation == 0


	
	
