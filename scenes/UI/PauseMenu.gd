extends CanvasLayer

onready var continue_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton
onready var options_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quit_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

var options_menu_scene = preload("res://scenes/UI/OptionsMenu.tscn")

func _ready():
	continue_button.connect("pressed", self, "on_continue_pressed")
	options_button.connect("pressed", self, "on_options_pressed")
	quit_button.connect("pressed", self, "on_quit_pressed")
	get_tree().paused = true
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		unpause()
		get_tree().set_input_as_handled()

func unpause():
	queue_free()
	get_tree().paused = false

func on_continue_pressed():
	unpause()

func on_options_pressed():
	var options_menu_instance = options_menu_scene.instance()
	add_child(options_menu_instance)
	options_menu_instance.connect("back_pressed", self, "on_options_back_pressed")
	$MarginContainer.visible = false

func on_quit_pressed():
	$"/root/ScreenTransitionManager".transition_to_menu()
	unpause()

func on_options_back_pressed():
	$OptionsMenu.queue_free()
	$MarginContainer.visible = true

