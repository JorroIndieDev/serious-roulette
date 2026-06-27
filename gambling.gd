class_name GamblingNode extends Control

@onready var prize_wheel: Node2D = $Prize_Wheel
@onready var slot_machine: Node2D = $"Slot-Machine"
@onready var prize: Control = $Prize
@onready var buttons: HBoxContainer = $HBoxContainer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

signal finished_gambling

signal esc_pressed()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and get_parent().visible:
		esc_pressed.emit()

func _ready() -> void:
	prize.visible = false

func _on_button_pressed() -> void:
	prize_wheel.spin()
	buttons.visible = false

func _on_button_2_pressed() -> void:
	slot_machine.spin()
	buttons.visible = false

func _spin_slot_machine() -> void:
	slot_machine.spin()

func _spin_prize_wheel() -> void:
	prize_wheel.spin()


func show_prize(win_texture : Texture2D, win_title : String, win_desc : String):
	var texture:TextureRect = $Prize/Prize
	var shine:TextureRect =$Prize/Shine
	var title:Label = $Prize/text/Title
	var desc:Label = $Prize/text/Description
	
	#prize.scale = Vector2(0.1,0.1)
	texture.texture = win_texture
	texture.size = Vector2(70,70) ##TODO Change ?
	texture.position = Vector2(140,50)
	texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	title.text = win_title
	title.add_theme_color_override("font_outline_color", Color.BLACK)
	title.add_theme_constant_override("outline_size", 8)
	desc.text = win_desc
	desc.add_theme_color_override("font_outline_color", Color.BLACK)
	desc.add_theme_constant_override("outline_size", 4)
	prize.visible = true
	var tween = create_tween()
	tween.tween_property(shine, "rotation", 1, 1.5)
	#tween.tween_property(prize, "scale", Vector2(1,1), 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	audio_player.play()
	
	await get_tree().create_timer(1.5).timeout
	prize.visible = false
	#buttons.visible = true
	finished_gambling.emit()
