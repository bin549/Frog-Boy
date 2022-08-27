extends KinematicBody2D

export(Resource) var moveData = preload("res://DefaultPlayerMovementData.tres") as PlayerMovementData

var velocity = Vector2.ZERO
onready var remoteTransform2D: = $RemoteTransform2D

func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	move_state(input)

func move_state(input):
	if not horizontal_move(input):
		apply_friction()
	else:
		apply_acceleration(input.x)
	apply_gravity()
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, 300)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICION)

func horizontal_move(input):
	return input.x != 0

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path
