extends KinematicBody2D

export(Resource) var moveData = preload("res://DefaultPlayerMovementData.tres") as PlayerMovementData

var velocity = Vector2.ZERO
onready var sprite: = $Sprite
onready var remoteTransform2D: = $RemoteTransform2D

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	move_state(input)

func move_state(input):
	if not input.x != 0:
		apply_friction()
	else:
		apply_acceleration(input.x)
		sprite.flip_h = input.x < 0
	if can_jump():
		input_jump()
	apply_gravity()
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)

func input_jump():
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = moveData.JUMP_FORCE

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICION)

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path

func can_jump():
	return is_on_floor()
