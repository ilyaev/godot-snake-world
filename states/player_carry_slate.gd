extends State
class_name PlayerCarrySlate

@export var player : Player

func Enter():
	print('Enter state: ', name, ' for ', player.player)
	player.get_node("head/slate").show()
	player.get_node("head/slate").set_instance_shader_parameter('color', player.slate_color)
	
	
func Physics_Update(delta):
	var slate = player.get_node("head/slate")
	var multiplier = 5
	slate.rotate_x(delta * PI/4 * multiplier)
	slate.rotate_y(delta * PI/2 * multiplier)
	slate.rotate_z(delta * PI/8 * multiplier)
	
	
