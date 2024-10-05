extends CanvasLayer

onready var continue_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton

func _ready():
	continue_button.connect("pressed", self, "on_continue_pressed")
	
func on_continue_pressed():
	$"/root/ScreenTransitionManager".transition_to_menu()
