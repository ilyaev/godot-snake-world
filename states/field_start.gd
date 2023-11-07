extends State
class_name FieldStart

@export var field : Field


func Enter():
	for player in field.get_players():
		player.set_state("PlayerStarting")
	var screen = field.get_node("%screen")
	screen.show()
	screen.get_node("AnimationPlayer").play("show")
	
func Exit():
	for player in field.get_players():
		player.set_state("PlayerNormal")
	field.get_node("%screen").hide()
