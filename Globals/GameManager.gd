extends Node

var ProjectileContainer: Node
var CoinContainer: Node
var main_menu: MainMenu
var _HUD: HUD
var _RespawnMenu: RespawnMenu 

var SubUI_Opened: bool = false

var game_start_time

#region Leaderboard content
var player_id: int = 0
var max_name_legth: int = 3
var player_name: String = "p01"

var player_score: int = 0
var previews_player_score: int = 0

var max_leader_board_track: int = 10
var leaderboard_track: Dictionary[int,Dictionary] = {}
#endregion

func _ready() -> void:
	pass

func _play_button() -> void:
	#change_scene(main_menu.game_scene)
	#game_start_time = Time.get_unix_time_from_system()
	#print(game_start_time)
	pass

func change_scene(scene: PackedScene, change_mouse_mode: bool = true) -> void:
	if get_tree().paused: get_tree().paused = false
	get_tree().change_scene_to_packed(scene)
	if change_mouse_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)   

func _player_leveled() -> void:
	#PauseManager.set_state(PauseManager.PauseState.PAUSED)
	PlayerData.leveled_up = false

func spawn_coin(pos: Vector2, coin_val: int = 0) -> void:
	
	var coin_data = CoinData.new()
	coin_data.coin_value = coin_data.coin_value if coin_val == 0 else coin_val
	var coin: Coin = coin_data.coin_scene.instantiate()
	coin.coin_data = coin_data
	CoinContainer.call_deferred("add_child", coin)
	coin.position = pos

func _update_hud_coins(ammount: int) -> void:
	if _HUD:
		_HUD._update_coins(ammount)
		print("MEGAGAY")
func _update_hud_points(ammount: int) -> void:
	if _HUD:
		_HUD._update_points(ammount)
		print("MEGAGAYYY")

func _update_leaderboard() -> void:
	previews_player_score = player_score
	if leaderboard_track.is_empty():
		leaderboard_track[player_id] = {player_name:player_score}
		return
	
	player_id += 1
	leaderboard_track[player_id] = {player_name:player_score}

func player_died() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_RespawnMenu.visible = true

func _player_respawn() -> void:
	if get_tree().paused:
		get_tree().paused = false
	PlayerData._respawn_player()
	#_PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)


func quit_game() -> void:
	get_tree().quit()

func reset_game() -> void:
	_update_leaderboard()
	PlayerData.reset_data()
	_update_hud_coins(0)
	_update_hud_points(0)



#EOF
