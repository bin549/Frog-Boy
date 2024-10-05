extends HBoxContainer

signal percentage_changed

var current_percentage = 1.0

func _ready():
	$SubtractButton.connect("pressed", self, "on_button_pressed", [-.1])
	$AddButton.connect("pressed", self, "on_button_pressed", [.1])

func set_current_percentage(percent):
	current_percentage = clamp(percent, 0, 1)
	var label_number = current_percentage * 10
	label_number = round(label_number)
	$Label.text = str(label_number)
	emit_signal("percentage_changed", current_percentage)

func on_button_pressed(change):
	set_current_percentage(current_percentage + change)
