extends State
class_name PlayerEliminated

@export var player : Player


func Enter():
	print('Enter state: ', name, ' for ', player.player)
	player.get_node("head/slate").hide()
	if multiplayer.is_server():
		for tail in player.get_node("Tails").get_children():
			tail.queue_free()
			player.pos = Vector3(0,0,0)
			player.get_node("head").position = player.pos
			player.get_node("PlayerInput").direction = Vector3(1,0,0)
			player.get_node("PlayerInput").next_direction = Vector3(1,0,0)
	get_parent().transit("PlayerNormal")
	pass


func Physics_Update(delta):
	pass
