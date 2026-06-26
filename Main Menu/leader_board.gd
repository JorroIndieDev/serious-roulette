class_name LeaderBoardUI extends Control

const LEADERBOARD_SCORE_CONTAINER = preload("uid://c041j45c33o4c")

var populate: bool

func _ready() -> void:
	populate = GameManager.leaderboard_track.is_empty()

	if populate:
		populate_leaderboard()


func populate_leaderboard() -> void:
	pass
