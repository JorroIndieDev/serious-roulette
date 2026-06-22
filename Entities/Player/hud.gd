class_name HUD extends CanvasLayer

@export var coin_label: Label
@export var point_label: Label
@export var label_settings: LabelSettings

func _ready() -> void:
	GameManager._HUD = self

func _update_coins(ammount: int) -> void:
	coin_label.text = str(ammount)
func _update_points(ammount: int) -> void:
	point_label.text = str(ammount)
