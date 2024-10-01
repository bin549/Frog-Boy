extends Camera2D

var target_position = Vector2.ZERO

export(Color, RGB) var background_color = Color( 0.87451, 0.964706, 0.960784, 1 )

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
	
func acquire_target_position():
	var acquired = get_target_position_from_node_group("player")
	
func get_target_position_from_node_group(groupName):
	var nodes = get_tree().get_nodes_in_group(groupName)
	if nodes.size() > 0:
		var node = nodes[0]
		target_position = node.global_position
		return true
	return false
