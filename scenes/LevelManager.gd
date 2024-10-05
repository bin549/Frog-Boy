extends Node

export(Array, PackedScene) var level_scenes

var current_level_index = 0

func change_level(level_index):
	current_level_index = level_index
	if current_level_index >= level_scenes.size():
		$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/UI/GameComplete.tscn")
	else:
		$"/root/ScreenTransitionManager".transition_to_scene(level_scenes[current_level_index].resource_path)

func increment_level():
	change_level(current_level_index + 1)

func restart_level():
	change_level(current_level_index)
