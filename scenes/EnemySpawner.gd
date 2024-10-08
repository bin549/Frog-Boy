extends Position2D

enum Direction { RIGHT, LEFT }

export(PackedScene) var enemy_scene
export(Direction) var start_direction

var current_enemy_node = null
var spawn_on_next_tick = false

func _ready():
	$SpawnTimer.connect("timeout", self, "on_spawn_timer_timeout")
	call_deferred("spawn_enemy")

func spawn_enemy():
	current_enemy_node = enemy_scene.instance()
	current_enemy_node.start_direction = Vector2.RIGHT if start_direction == Direction.RIGHT else Vector2.LEFT
	get_parent().add_child(current_enemy_node)
	current_enemy_node.global_position = global_position

func check_enemy_spawn():
	if !is_instance_valid(current_enemy_node):
		if spawn_on_next_tick:
			spawn_enemy()
			spawn_on_next_tick = false
		else:
			spawn_on_next_tick = true

func on_spawn_timer_timeout():
	check_enemy_spawn()
