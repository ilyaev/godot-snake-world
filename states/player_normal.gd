extends State
class_name PlayerNormal

@export var player : Player

func Enter():
	print('Enter state: ', name, ' for ', player.player)
	player.get_node("head/slate").hide()
	
func Exit():
	pass
