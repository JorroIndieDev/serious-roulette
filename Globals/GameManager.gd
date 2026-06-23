extends Node

var ProjectileContainer: Node
var CoinContainer: Node
var main_menu: MainMenu
var _HUD: HUD
var _RespawnMenu: RespawnMenu 

#region Leaderboard content
var player_id: int = 0
var max_name_legth: int = 3
var player_name: String = "p01"

var player_score: int = 0
var previews_player_score: int = 0

var max_leader_board_track: int = 10
var leaderboard_track: Dictionary[int,Dictionary] = {}
#endregion

#func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)   

func _play_button() -> void:
	change_scene(main_menu.game_scene)

func change_scene(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)   

func _player_leveled() -> void:
	PlayerData.leveled_up = false
	print("Player Leveled")

func spawn_coin(pos: Vector2, coin_val: int = 0) -> void:
	
	var coin_data = CoinData.new()
	coin_data.coin_value = coin_data.coin_value if coin_val == 0 else coin_val
	var coin: Coin = coin_data.coin_scene.instantiate()
	coin.coin_data = coin_data
	CoinContainer.call_deferred("add_child", coin)
	coin.position = pos

func _update_hud_coins(ammount: int) -> void:
	_HUD._update_coins(ammount)
func _update_hud_points(ammount: int) -> void:
	_HUD._update_points(ammount)

func _update_leaderboard() -> void:
	print(player_name.left(max_name_legth))
	previews_player_score = player_score
	if leaderboard_track.is_empty():
		leaderboard_track[player_id] = {player_name:player_score}
		return
	
	player_id += 1
	leaderboard_track[player_id] = {player_name:player_score}

func player_died() -> void:
	get_tree().paused = true
	_RespawnMenu.visible = true

func _player_respawn() -> void:
	if get_tree().paused:
		get_tree().paused = false
	PlayerData._respawn_player()

func quit_game() -> void:
	get_tree().quit()




#EOF
