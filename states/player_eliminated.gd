extends State
class_name PlayerEliminated

@export var player : Player


func Enter():
	player.add_score.rpc(0)
	player.get_node("Title").hide()
	player.get_node("head/slate").hide()
	for tail in player.get_node("Tails").get_children():
		tail.explode()
	player.get_node("PlayerInput").direction = Vector3(0,0,0)
	player.get_node("PlayerInput").next_direction = player.get_node("PlayerInput").direction
	await get_tree().create_timer(1.).timeout
	player.set_state("PlayerNormal")


func Physics_Update(_delta):
	pass
