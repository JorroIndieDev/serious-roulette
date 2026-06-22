extends Node2D

signal prize_won(reward: Upgrade)

@onready var background: AnimatedSprite2D = $Background
@onready var numbers: AnimatedSprite2D = $Numbers
@onready var prize: Control = $"../Prize"

@export var spin_duration: float = 2.0
@export var height_to_slide: float = 170
@export var time_to_slide: float = 0.5
@export var display_duration: float = 2.5
@export var gambling_node: GamblingNode
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer


var offscreen_y: float
var onscreen_y: float
var winning_prize: Upgrade
var num_prizes: int = 3
@onready var icons_container: Node2D = $PrizeContainer

func _ready() -> void:
	
	connect("prize_won", PlayerData._append_upgrade)
	
	offscreen_y = position.y
	onscreen_y = offscreen_y - height_to_slide
	position.x = get_viewport_rect().size.x/2
	icons_container.visible = false
	numbers.visible = true
	icons_container.visible = false
	for i in range(3):
		var prize_sprite = icons_container.get_child(i) as Sprite2D
		prize_sprite.texture = null
	

func spin():
	winning_prize = UpgradeDB._populate_random(1)[0]
	
	numbers.visible = true
	icons_container.visible = false
	for i in range(3):
		var prize_sprite = icons_container.get_child(i) as Sprite2D
		prize_sprite.texture = null
		
	background.play("Spinning")
	numbers.play("Spin")
	audio_player.play()
	var tween = create_tween()
	tween.tween_property(self, "position:y", onscreen_y, time_to_slide).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	
	await get_tree().create_timer(spin_duration).timeout
	
	background.play("Stop")
	audio_player.stop()
	numbers.visible = false
	
	icons_container.visible = true
	for i in range(3):
		var prize_sprite = icons_container.get_child(i) as Sprite2D
		prize_sprite.texture = winning_prize.texture
		await get_tree().create_timer(0.2).timeout
		
	gambling_node.show_prize(winning_prize.texture, winning_prize.name, winning_prize.description)
	await get_tree().create_timer(display_duration).timeout
	
	prize_won.emit(winning_prize)
	var tween_out = create_tween()
	tween_out.tween_property(self, "position:y", offscreen_y, time_to_slide).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
