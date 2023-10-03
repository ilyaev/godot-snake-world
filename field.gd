extends Node3D

const SPAWN_RANDOM := 10.0

var T := 0.0

@export var player_scene : PackedScene
@export var food_scene : PackedScene

func _ready():
	# We only need to spawn players on the server.
	set_physics_process(multiplayer.is_server())

	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn random food
	for i in 5:
		spawn_food()

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)




func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id: int):
	var character = player_scene.instantiate()
	character.player = id
	character.sync_position(Vector3(randf_range(-8, 8), randf_range(-8,8), 0))
	character.name = str(id)
	character.title = get_random_name()
	print('Add Player', [id, multiplayer.get_unique_id()])
	if id == multiplayer.get_unique_id():
		character.change_position.connect(sync_camera)
	$Players.add_child(character, true)


func sync_camera(p_pos):
#	print('Sync Camera For: ', [multiplayer.get_unique_id(), p_pos])
	$Camera.position.x = p_pos.x
	$Camera.position.y = p_pos.y

func get_random_name():
	var names = $Names.get_text().split("\n")
	return names[randi_range(0, names.size() - 1)]

func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()

# func _physics_process(delta):
# 	T += delta
# 	if T > 1.0:
# 		T = 0.0
# 		spawn_food()

func spawn_food():
	var food = food_scene.instantiate()
	food.position = Vector3(randf_range(-15, 15),randf_range(-10, 10),0)
	$Objects.add_child(food, true)

func _on_players_spawner_spawned(node):
	print('Spawn: ', [node.player, multiplayer.get_unique_id()])
	if node.player == multiplayer.get_unique_id():
		node.change_position.connect(sync_camera)
