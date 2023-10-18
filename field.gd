extends Node3D

const SPAWN_RANDOM := 10.0

var T := 0.0

@export var player_scene : PackedScene

func _ready():
	# We only need to spawn players on the server.
	set_physics_process(multiplayer.is_server())
	
	# Connect camera to player position
	Events.connect("player_position", func (pos): $Camera.position = Vector3(pos.x, pos.y, $Camera.position.z))

	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)
	
	
func _physics_process(delta):
	T += delta
	manage_food(delta)
	
func manage_food(delta):
	if T > 2 and $Objects.get_child_count() < $Players.get_child_count() * 3:
		T = 0
		spawn_food()

func spawn_food():
	var food = preload("res://food.tscn").instantiate()
	food.position = Vector3(randf_range(-15, 15),randf_range(-10, 10),.8)
	Callable($Objects.add_child).call_deferred(food, true)

func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id: int):
	var character = player_scene.instantiate()
	character.player = id
	character.name = str(id)
	character.index = $Players.get_child_count()
	if id != 1:
		var pos = Vector3(-5 + 2 * $Players.get_child_count(), 3 * $Players.get_child_count(), 0)
		character.pos = pos
		character.get_node('head').position = pos
	Callable($Players.add_child).call_deferred(character, true)


func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()


func _on_players_spawner_spawned(node):
	node.get_node('head').position = node.pos
