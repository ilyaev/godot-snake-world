extends State
class_name PlayerNormal

@export var player : Player

func Enter():
	player.get_node("head/slate").hide()
	#player.get_node("Title").show()
	
func Exit():
	pass
