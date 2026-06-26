class_name LeaderBoardUI extends Control

const LEADERBOARD_SCORE_CONTAINER = preload("uid://c041j45c33o4c")
@onready var _leaderboard: VBoxContainer = $VBoxContainer

var populate: bool

func _ready() -> void:
	populate = !GameManager.leaderboard_track.is_empty()

	if populate:
		populate_leaderboard()
	else: pass


func populate_leaderboard() -> void:
	var list = GameManager.leaderboard_track.keys()
	print(list.size())
	for k in list:
		var c: LeaderBoardScoreContainer = LEADERBOARD_SCORE_CONTAINER.instantiate()
		# add child
		_leaderboard.add_child(c)
		c._name.text = GameManager.leaderboard_track[k][0]["player_name"]
		c._points.text= str(GameManager.leaderboard_track[k][1]["player_score"])
