extends State
class_name FieldGameover

@export var field : Field

func Enter():
	get_parent().get_node("%screen").get_node("AnimationPlayer").play("show")
	get_parent().get_node("%screen").show()
	await get_tree().create_timer(.7).timeout
	get_parent().transit("FieldStart")
	
func Exit():
	get_parent().get_node("%screen").hide()
	pass
