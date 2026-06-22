extends Node

var ProjectileContainer: Node
var CoinContainer: Node
var main_menu: MainMenu
var _HUD: HUD

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)   

func _play_button() -> void:
	change_scene(main_menu.game_scene)

func change_scene(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)

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
