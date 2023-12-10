extends Node

const PORT = 4433

@export var level_scene : PackedScene
var current_level : Field
var single_player := false
var peer = false

func _ready():
	# Start paused
	get_tree().paused = true
	# You can save bandwith by disabling server relay and peer notifications.
	#multiplayer.server_relay = false

	# Automatically start the server in headless mode.
	#if DisplayServer.get_name() == "headless" or 1 == 1:
		#print("Automatically starting dedicated server")
		#Callable(_on_host_pressed).call_deferred()
		#return
	
	%MainMenu.single_player.connect(func(): single_player = true; _on_host_pressed())
	%MainMenu.multi_player.connect(_on_connect_pressed)

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		exit_main_menu()
		
func _on_host_pressed():
	# Start as server
	print([single_player,multiplayer.multiplayer_peer])
	if single_player and !(peer is ENetMultiplayerPeer):
		start_game()
		return	
	peer = ENetMultiplayerPeer.new()
	var result = peer.create_server(PORT)
	if result != OK and single_player == false:
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

func exit_main_menu():
	$UI.show()
	#$Level.hide()
	get_tree().paused = true
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()

func _input(event):
	if multiplayer.is_server():
		if event.is_action_pressed("ui_accept"):
			print("Next Level")
			current_level = $Level.get_child(0)
			current_level.next_level()
	if event.is_action_pressed("ui_cancel"):
		exit_main_menu()
