extends CanvasLayer

signal back_pressed

onready var back_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var window_mode_button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WindowModeButton
onready var music_range_control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/RangeControl
onready var sfx_range_control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeContainer/RangeControl

var fullscreen = false

func _ready():
	window_mode_button.connect("pressed", self, "on_window_mode_pressed")
	back_button.connect("pressed", self, "on_back_pressed")
	music_range_control.connect("percentage_changed", self, "on_music_volume_changed")
	sfx_range_control.connect("percentage_changed", self, "on_sfx_volume_changed")
	update_display()
	update_initial_volume_settings()

func update_display():
	window_mode_button.text = "WINDOWED" if !fullscreen else "FULLSCREEN"

func update_bus_volume(bus_name, volume_percent):
	var bus_idx = AudioServer.get_bus_index(bus_name)
	var volume_db = linear2db(volume_percent)
	AudioServer.set_bus_volume_db(bus_idx, volume_db)

func get_bus_volume_percent(bus_name):
	var bus_idx = AudioServer.get_bus_index(bus_name)
	var volume_percent = db2linear(AudioServer.get_bus_volume_db(bus_idx))
	return volume_percent

func update_initial_volume_settings():
	var music_percent = get_bus_volume_percent("Music")
	music_range_control.set_current_percentage(music_percent)
	var sfx_percent = get_bus_volume_percent("SFX")
	sfx_range_control.set_current_percentage(sfx_percent)

func on_window_mode_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()

func on_back_pressed():
	emit_signal("back_pressed")

func on_music_volume_changed(percent):
	update_bus_volume("Music", percent)

func on_sfx_volume_changed(percent):
	update_bus_volume("SFX", percent)
