extends State
class_name FieldGame

@export var field : Field

func Enter():
	var screen = field.get_node("%screen")
	screen.hide()
	
func Exit():
	pass
