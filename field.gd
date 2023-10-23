@tool
extends Node3D

const SPAWN_RANDOM := 10.0

var T := 0.0

@export var player_scene : PackedScene
@export var slate_colors : Array[Color] = []
@export var noise_texture : Texture

var empty_map : Dictionary = {}
var color_map : Dictionary = {}

func _ready():
	# We only need to spawn players on the server.
	set_physics_process(multiplayer.is_server())
	
	# Connect camera to player position
	Events.PLAYER_POSITION.connect(func (pos): $Camera.position = Vector3(pos.x, pos.y, $Camera.position.z))
	$screen.show()
	$screen/AnimationPlayer.play("fade")
	$board.get_active_material(0).set_shader_parameter("noise", noise_texture)

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
	
	var level_image = noise_texture.get_image()	
	for x in range(-9, 10):
		for y in range(-9, 10):
			var is_empty = false
			var pixel = level_image.get_pixelv(Vector2(x, y * -1) + Vector2(10, 10)).r
			if pixel > .1:
				is_empty = true
			empty_map[str(x) + '_' + str(y)] = is_empty
	
	
func _physics_process(delta):
	T += delta
	manage_food(delta)
	
func get_foods():
	var res := []
	for obj in $Objects.get_children():
		if obj is Food:
			res.push_back(obj)
	return res	
	
func manage_food(_delta):
	if T > 2 and get_foods().size() < $Players.get_child_count() * 3:
		T = 0
		spawn_food()

func spawn_food():
	var food = preload("res://food.tscn").instantiate()
	var food_pos
	for i in range(0,20):
		food_pos = Vector3(randi_range(-8, 8) * 2 + 1,randi_range(-8, 8) * 2 + 1,.8)
		if is_board_empty(food_pos):
			break
	food.position = food_pos
	food.type = 'food'
	if randf() > .2:
		food.type = 'slate'
		food.color = slate_colors[randi_range(0, slate_colors.size() - 1)]
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
		var pos = Vector3(float(randi_range(-SPAWN_RANDOM, SPAWN_RANDOM)), float(randi_range(-SPAWN_RANDOM, SPAWN_RANDOM)), 0)
		character.pos = pos
		character.get_node('head').position = pos
	if multiplayer.is_server():
		character.change_cell.connect(on_player_cell_change)
	Callable($Players.add_child).call_deferred(character, true)


func is_board_empty(cell_pos):
	var key = str(cell_pos.x) + '_' + str(cell_pos.y + 1)
	if empty_map.has(key):
		return empty_map[key]
	return false
	
func get_nearest_same_color(pos : Vector2, color : Color, list : Dictionary):
	list[get_cell_key(pos)] = true
	for x in range(pos.x - 1, pos.x + 2):
		for y in range(pos.y - 1 , pos.y + 2):
			if x == pos.x || y == pos.y:
				var key = get_cell_key(Vector2(x,y))
				if color_map.has(key) && color_map[key] == color && !list.has(key):
					list[key] = true
					list = get_nearest_same_color(Vector2(x,y), color, list)	
	return list
				

func on_player_cell_change(cell_pos, player):
	if !multiplayer.is_server():
		return
	var is_empty = is_board_empty(cell_pos)
	if is_empty && player.get_state() == 'PlayerCarrySlate':
		var slate = preload("res://slate.tscn").instantiate()
		slate.x = cell_pos.x
		slate.y = cell_pos.y
		slate.color = player.slate_color
		$Objects.add_child(slate, true)
		player.set_state("PlayerNormal")
		var key = get_cell_key(cell_pos)
		empty_map[key] = false
		color_map[key] = slate.color
		var score = get_nearest_same_color(cell_pos, slate.color, {}).size()
		for i in range(0, score):
			player.spawn_tail()
		
		

func get_cell_key(cell_pos):
	return str(cell_pos.x)+'_'+str(cell_pos.y + 1)

func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()


func _on_players_spawner_spawned(node):
	node.get_node('head').position = node.pos


func _on_animation_player_animation_finished(_anim_name):
	remove_child($screen)
