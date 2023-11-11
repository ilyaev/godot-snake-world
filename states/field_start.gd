extends State
class_name FieldStart

@export var field : Field


func Enter():
	var screen = field.get_node("%screen")
	screen.show()
	screen.get_node("AnimationPlayer").play("show")
	
func Exit():
	field.get_node("%screen").hide()
