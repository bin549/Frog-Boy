extends CharacterBody2D

@export var run_speed = 150.0
@export var jump_force := -300.0

var gravity := ProjectSettings.get("physics/2d/default_gravity") as float
var jump_count = 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	velocity.x = direction * run_speed
	velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump_count += 1
		$JumpSound.play()
		velocity.y = jump_force
	
	if not is_zero_approx(direction):
		sprite_2d.flip_h = direction < 0
	move_and_slide()
