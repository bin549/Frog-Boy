extends Node

export(int) var number_to_play = 2
export(bool) var enable_pitch_randomization = true
export(float) var min_pitch_scale = .9
export(float) var max_pitch_scale = 1.1

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func play():
	var valid_nodes = []
	for stream_player in get_children():
		if !stream_player.playing:
			valid_nodes.append(stream_player)
	for i in number_to_play:
		if valid_nodes.size() == 0:
			break
		var idx = rng.randi_range(0, valid_nodes.size() - 1)
		if enable_pitch_randomization:
			valid_nodes[idx].pitch_scale = rng.randf_range(min_pitch_scale, max_pitch_scale)
		valid_nodes[idx].play()
		valid_nodes.remove(idx)
