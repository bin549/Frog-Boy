extends Node

onready var animation_player = AnimationPlayer

func start_game():
	go_to_world("res://scenes/World.tscn")


func go_to_world(path):
	_animate_transition_to(path)

func _animate_transition_to(path):
	# animation_player.play_backwards("fade-in")
	get_tree().change_scene(path)
