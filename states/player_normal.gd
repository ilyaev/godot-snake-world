extends State
class_name PlayerNormal

@export var player : Player

func Enter():
	player.get_node("head/slate").hide()
	
func Exit():
	pass
