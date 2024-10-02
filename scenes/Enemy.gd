extends KinematicBody2D

var enemy_death_scene = preload("res://scenes/EnemyDeath.tscn")

export var is_spawning = true
var max_speed = 25
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500
var start_direction = Vector2.RIGHT

func _ready():
	direction = start_direction
	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")

func _process(delta):
	if is_spawning:
		return
	velocity.x = (direction * max_speed).x
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	$Visuals/AnimatedSprite.flip_h = true if direction.x > 0 else false

func kill():
	var death_instance = enemy_death_scene.instance()
	get_parent().add_child(death_instance)
	death_instance.global_position = global_position
	if velocity.x > 0:
		death_instance.scale = Vector2(-1, 1)
	queue_free()

func on_goal_entered(_area2d):
	direction *= -1;

func on_hitbox_entered(_area2d):
	call_deferred("kill")
