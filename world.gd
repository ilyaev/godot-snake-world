extends Node3D

var camera
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var food_scene: PackedScene
var mid = 0

var connected = false

var T = 0

func _ready():
	camera = $camera

func _enter_tree():
	var result = _on_host_pressed()
	if result != OK:
		_on_join_pressed()
		
		
func _process(delta):
	T += delta
	$fps.set_text("FPS " + str(Engine.get_frames_per_second()) + ' / Items: ' + str(get_child_count()))
	if connected:
		if multiplayer.is_server():
			if T > 1:
				spawn_food()
				T = 0
			
func _on_host_pressed():
	var success = peer.create_server(4002)
	
	if success == OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_add_player)
		mid = multiplayer.get_unique_id()
		$label_type.set_text("SERVER: " + str(mid))
		_init_server()
		_add_player()
		moveWindow()
		connected = true
		
	return success
	
func _init_server():
	print('Init Server!')


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
#	print("Add Player:", get_type(), [id, player.get_head().position, player.pos, player.name])
	call_deferred("add_child", player)
	
func _on_join_pressed():
#	await get_tree().create_timer(2.0).timeout
	peer.create_client("localhost", 4002)
	multiplayer.multiplayer_peer = peer
	mid = multiplayer.get_unique_id()
	$label_type.set_text("CLIENT: " + str(mid))
	connected = true

func moveWindow():
	get_window().position = Vector2(1150,0)

func get_type():
	return $label_type.get_text()


func spawn_food():
	var one = food_scene.instantiate()
	one.set_multiplayer_authority(1)
	call_deferred("add_child", one, true)
