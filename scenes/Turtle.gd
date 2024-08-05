extends Node2D

@onready var animated_sprite = $AnimatedSprite2D

func rotate_sprite(is_flip: bool):
	animated_sprite.flip_h = is_flip
