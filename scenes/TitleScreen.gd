extends Control

onready var transitions = $UI/Menus/Transitions


func _on_StartButton_pressed():
	Globals.start_game()
