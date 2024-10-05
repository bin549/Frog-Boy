extends Node

var screen_transition_scene = preload("res://scenes/UI/ScreenTransition.tscn")

func transition_to_scene(scenePath):
	for button in get_tree().get_nodes_in_group("animated_button"):
		button.disabled = true
	yield(get_tree().create_timer(.1), "timeout")
	var screen_transition = screen_transition_scene.instance()
	add_child(screen_transition)
	yield(screen_transition, "screen_covered")
	get_tree().change_scene(scenePath)

func transition_to_menu():
	transition_to_scene("res://scenes/UI/MainMenu.tscn")
