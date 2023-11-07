extends State
class_name PlayerStarting

@export var player : Player

func Enter():
	player.get_node("Title").hide()
	player.get_node("head/slate").hide()
	
func Exit():
	pass
	#player.get_node("Title").show()
