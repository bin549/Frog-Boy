extends CanvasLayer

onready var play_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
onready var options_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quit_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready():
	play_button.connect("pressed", self, "on_play_pressed")
	quit_button.connect("pressed", self, "on_quit_pressed")
	options_button.connect("pressed", self, "on_options_pressed")

func on_play_pressed():
	$"/root/LevelManager".change_level(0)

func on_quit_pressed():
	get_tree().quit()

func on_options_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene("res://scenes/UI/OptionsMenuStandalone.tscn")
