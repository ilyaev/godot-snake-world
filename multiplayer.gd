extends Node

const PORT = 4433

@export var level_scene : PackedScene
var current_level : Field

func _ready():
	# Start paused
	get_tree().paused = true
	# You can save bandwith by disabling server relay and peer notifications.
	#multiplayer.server_relay = false

	# Automatically start the server in headless mode.
	if DisplayServer.get_name() == "headless" or 1 == 1:
		print("Automatically starting dedicated server")
		Callable(_on_host_pressed).call_deferred()


func _on_host_pressed():
	# Start as server
	var peer = ENetMultiplayerPeer.new()
	var result = peer.create_server(PORT)
	if result != OK:
		#await get_tree().create_timer(randf_range(3.0, 10.0)).timeout
		_on_connect_pressed()
		return result
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server")
		return 20
	multiplayer.multiplayer_peer = peer
	start_game()
	# get_window().position = Vector2(1150, 0)
	return result


func _on_connect_pressed():
	# Start as client
	var txt : String = %Remote.text
	if txt == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client")
		return
	multiplayer.multiplayer_peer = peer
	start_game()

func start_game():
	# Hide the UI and unpause to start the game.
	$UI.hide()
	get_tree().paused = false
	# Only change level on the server.
	# Clients will instantiate the level via the spawner.
	if multiplayer.is_server():
		Callable(change_level).call_deferred(level_scene)


# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene):
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	Callable(level.add_child).call_deferred(scene.instantiate())

func _input(event):
	if multiplayer.is_server():
		if event.is_action_pressed("ui_accept"):
			print("Next Level")
			current_level = $Level.get_child(0)
			current_level.next_level()
