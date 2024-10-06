extends Node
 
signal coin_total_changed

export(PackedScene) var level_complete_scene

var player_scene = preload("res://scenes/Player.tscn")
var pause_scene = preload("res://scenes/UI/PauseMenu.tscn")
var spawn_position = Vector2.ZERO
var current_player_node = null
var total_coins = 0
var collected_coins = 0

func _ready():
	spawn_position = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())
	$Flag.connect("player_won", self, "on_player_won")

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_instance = pause_scene.instance()
		add_child(pause_instance)

func coin_collected():
	collected_coins += 1
	emit_signal("coin_total_changed", total_coins, collected_coins)

func coin_total_changed(new_total):
	total_coins = new_total
	emit_signal("coin_total_changed", total_coins, collected_coins)
	
func register_player(player):
	current_player_node = player
	current_player_node.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)

func create_player():
	var player_instance = player_scene.instance()
	$PlayerRoot.add_child(player_instance)
	player_instance.global_position = spawn_position
	register_player(player_instance)
	
func on_player_died():
	current_player_node.queue_free()
	var timer = get_tree().create_timer(1.5)
	yield(timer, "timeout")
	create_player()

func on_player_won():
	current_player_node.disable_player_input()
	var level_complete = level_complete_scene.instance()
	add_child(level_complete)

