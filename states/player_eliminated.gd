extends State
class_name PlayerEliminated

@export var player : Player


func Enter():
	player.get_node("Title").hide()
	player.get_node("head/slate").hide()
	for tail in player.get_node("Tails").get_children():
		tail.explode()
	player.get_node("PlayerInput").direction = Vector3(0,0,0)
	player.get_node("PlayerInput").next_direction = player.get_node("PlayerInput").direction
	await get_tree().create_timer(1.).timeout
	player.pos = Vector3(randi_range(-5,5),randi_range(-5,5),0)
	player.get_node("head").position = player.pos
	
	get_parent().transit("PlayerNormal")


func Physics_Update(delta):
	pass
