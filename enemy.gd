extends CharacterBody2D

@export var gravity = 900

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
