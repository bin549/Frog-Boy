extends Camera2D

var target_position = Vector2.ZERO

export(Color, RGB) var background_color
export(OpenSimplexNoise) var shake_noise

var x_noise_sample_vector = Vector2.RIGHT
var y_noise_sample_vector = Vector2.DOWN
var x_noise_sample_position = Vector2.ZERO
var y_noise_sample_position = Vector2.ZERO
var noise_sample_travel_rate = 500
var max_shake_offset = 10
var current_shake_percentage = 0
var shake_decay = 3

func _ready():
	VisualServer.set_default_clear_color(background_color)
	
func _process(delta):
	acquire_target_position()
	global_position = lerp(target_position, global_position, pow(2, -15 * delta))
	if current_shake_percentage > 0:
		x_noise_sample_position += x_noise_sample_vector * noise_sample_travel_rate * delta
		y_noise_sample_position += y_noise_sample_vector * noise_sample_travel_rate * delta
		var x_sample = shake_noise.get_noise_2d(x_noise_sample_position.x, x_noise_sample_position.y)
		var y_sample = shake_noise.get_noise_2d(y_noise_sample_position.x, y_noise_sample_position.y)
		var calculated_offset = Vector2(x_sample, y_sample) * max_shake_offset * pow(current_shake_percentage, 2)
		offset = calculated_offset
		current_shake_percentage = clamp(current_shake_percentage - shake_decay * delta, 0, 1)

func apply_shake(percentage):
	current_shake_percentage = clamp(current_shake_percentage + percentage, 0, 1)

func acquire_target_position():
	var acquired = get_target_position_from_node_group("player")
	if !acquired:
		get_target_position_from_node_group("player_death")

func get_target_position_from_node_group(groupName):
	var nodes = get_tree().get_nodes_in_group(groupName)
	if nodes.size() > 0:
		var node = nodes[0]
		target_position = node.global_position
		return true
	return false
