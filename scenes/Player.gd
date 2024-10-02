extends KinematicBody2D

signal died

var footstep_particles = preload("res://scenes/FootstepParticles.tscn")

enum State { NORMAL, DASHING, INPUT_DISABLED }

export(int, LAYERS_2D_PHYSICS) var dash_hazard_mask

var gravity = 1000
var velocity = Vector2.ZERO
var max_horizontal_speed = 140
var max_dash_speed = 500
var min_dash_speed = 200
var horizontal_acceleration = 2000
var jump_speed = 300
var jump_termination_multiplier = 4
var has_double_jump = false
var has_dash = false
var current_state = State.NORMAL
var is_state_new = true
var is_dying = false
var default_hazard_mask = 0

func _ready():
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	$AnimatedSprite.connect("frame_changed", self, "on_animated_sprite_frame_changed")
	default_hazard_mask = $HazardArea.collision_mask

func _process(delta):
	match current_state:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
		State.INPUT_DISABLED:
			process_input_disabled(delta)
	is_state_new = false

func change_state(newState):
	current_state = newState
	is_state_new = true

func process_normal(delta):
	if is_state_new:
		$DashParticles.emitting = false
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = default_hazard_mask
	var move_vector = get_movement_vector()
	velocity.x += move_vector.x * horizontal_acceleration * delta
	if move_vector.x == 0:
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	velocity.x = clamp(velocity.x, -max_horizontal_speed, max_horizontal_speed)
	if move_vector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || has_double_jump):
		velocity.y = move_vector.y * jump_speed
		if !is_on_floor() && $CoyoteTimer.is_stopped():
			has_double_jump = false
		$CoyoteTimer.stop()
	if velocity.y < 0 && !Input.is_action_pressed("jump"):
		velocity.y += gravity * jump_termination_multiplier * delta
	else:
		velocity.y += gravity * delta
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	if was_on_floor && !is_on_floor():
		$CoyoteTimer.start()
	if !was_on_floor && is_on_floor() && !is_state_new:
		spawn_footsteps(1.5)
	if is_on_floor():
		has_double_jump = true
		has_dash = true
	if has_dash && Input.is_action_just_pressed("dash"):
		call_deferred("change_state", State.DASHING)
		has_dash = false
	update_animation()

func process_dash(delta):
	if is_state_new:
		$AnimatedSprite.play("jump")
		$DashParticles.emitting = true
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite.play("jump")
		$HazardArea.collision_mask = dash_hazard_mask
		var move_vector = get_movement_vector()
		var velocity_mod = 1
		if move_vector.x != 0:
			velocity_mod = sign(move_vector.x)
		else:
			velocity_mod = 1 if $AnimatedSprite.flip_h else -1
		velocity = Vector2(max_dash_speed * velocity_mod, 0)
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	if abs(velocity.x) < min_dash_speed:
		call_deferred("change_state", State.NORMAL)

func process_input_disabled(delta):
	if is_state_new:
		$AnimatedSprite.play("idle")
	velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func get_movement_vector():
	var move_vector = Vector2.ZERO
	move_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_vector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return move_vector

func update_animation():
	var move_vec = get_movement_vector()
	if !is_on_floor():
		$AnimatedSprite.play("jump")
	elif move_vec.x != 0:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
	if move_vec.x != 0:
		$AnimatedSprite.flip_h = true if move_vec.x > 0 else false

func kill():
	if is_dying:
		return
	is_dying = true


func spawn_footsteps(scale = 1):
	var footstep = footstep_particles.instance()
	get_parent().add_child(footstep)
	footstep.scale = Vector2.ONE * scale
	footstep.global_position = global_position

func on_hazard_area_entered(area2d):
	call_deferred("kill")
	
func on_animated_sprite_frame_changed():
	if $AnimatedSprite.animation == "run" && $AnimatedSprite.frame == 0:
		spawn_footsteps()
