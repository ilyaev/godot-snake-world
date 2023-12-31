@tool
extends Node3D
class_name Field

@export var player_scene : PackedScene
@export var slate_colors : Array[Color] = []
@export var max_level := 3
@export var level_id := 0:
	set(new_level_id):
		level_id = new_level_id
		level = load("res://levels/level"+str(new_level_id)+".tscn").instantiate()
		for child in get_children():
			if child is Level:
				level.block_queue.clear()
				$BlockRaiser.slate_queue.clear()
				child.queue_free()
		level.build_maps()
		empty_map = level.empty_map
		field_map = level.field_map
		block_map = level.block_map
		add_child.call_deferred(level)

var T := 0.0
var noise_texture : Texture
var level : Level
var empty_map : Dictionary = {}
var block_map : Dictionary = {}
var color_map : Dictionary = {}
var field_map = FieldMap.new()

func _ready():
	if Engine.is_editor_hint():
		return
	
	$StateMachine.Transitioned.connect(_on_state_change)
	
	Events.camera = $Camera
	
	set_physics_process(multiplayer.is_server())
	# Connect camera to player position
	Events.PLAYER_POSITION.connect(func (pos): $Camera.position = Vector3(pos.x, pos.y, $Camera.position.z))

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
		add_player(2)

func _physics_process(delta):
	T += delta
	manage_food(delta)

func get_players():
	return $Players.get_children()

func get_objects():
	return $Objects.get_children()

func get_foods():
	var res := []
	for obj in $Objects.get_children():
		if obj is Food:
			res.push_back(obj)
	return res

func manage_food(_delta):
	if T > 2. and get_foods().size() < $Players.get_child_count() * 3:
		T = 0
		spawn_food()

func spawn_food():
	var food = preload("res://food.tscn").instantiate()
	for i in range(0,40):
		var food_pos = level.find_empty_cell_center()
		food.position = Vector3(food_pos.x, food_pos.y, .8)
		var flag = true
		for obj in get_foods():
			if (food_pos - obj.position).length() < 3.:
				flag = false
		if flag:
			break
	food.type = 'food'
	if randf() > .15:
		food.type = 'slate'
		food.color = slate_colors[randi_range(0, slate_colors.size() - 1)]
	Callable($Objects.add_child).call_deferred(food, true)

func _exit_tree():
	if Engine.is_editor_hint():
		return
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func get_random_name():
	var names = $Names.get_text().split("\n")
	return names[randi_range(0, names.size() - 1)]


func add_player(id: int):
	var character = player_scene.instantiate()
	if id == 2:
		character.player = 1
	else:
		character.player = id
	character.name = str(id)
	character.title = get_random_name()
	character.index = $Players.get_child_count()
	
	var pos = level.find_empty_cell_center()
	character.pos = pos
	character.get_node('head').position = pos
	
	if id == 1:
		character.color = Vector3(.0,.0,.0)
		character.is_autopilot = true
		character.get_node('Autopilot').is_active = true
		character.get_node('Autopilot').field = self
		character.title = 'Void'
		
	character.get_node("Title").set_text(character.title)
	character.change_cell.connect(on_player_cell_change)
	character.change_state.connect(on_player_state_change)
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


func on_player_state_change(state : String, current_state : String, player : Player):
	#print([player.get_node('Title').get_text(), current_state,'->',state, multiplayer.is_server()])
	if multiplayer.is_server():
		if state == 'PlayerNormal' and current_state == 'PlayerEliminated':
			var pos = level.find_empty_cell_center()
			player.pos = pos
			player.get_node("head").position = pos
			
	if state == 'PlayerEliminated':
		if player.player == multiplayer.get_unique_id():
			$StateMachine.transit("FieldGameover")

func get_server_snake():
	for snake in $Players.get_children():
		if snake.is_autopilot:
			return snake
	return false

func on_player_cell_change(cell_pos, player):
	var is_empty = is_board_empty(cell_pos)
	if is_empty:
		if player.get_state() == 'PlayerCarrySlate':
			var slate = preload("res://slate.tscn").instantiate()
			slate.x = cell_pos.x
			slate.y = cell_pos.y
			slate.color = player.slate_color
			$Objects.add_child(slate, true)
			player.set_state("PlayerNormal")
			var key = get_cell_key(cell_pos)
			empty_map[key] = false
			color_map[key] = slate.color
			var nearest = get_nearest_same_color(cell_pos, slate.color, {})
			var score = nearest.size()
			player.add_score.rpc(score * 100)
			for i in range(0, score):
				player.spawn_tail()

			var snake = get_server_snake()

			if snake:
				var slate_score = 0
				for k_slate in nearest.keys():
					var pair = k_slate.split('_')
					for n_slate in $Objects.get_children():
						if n_slate is Slate:
							if n_slate.x == int(pair[0]) && n_slate.y == (int(pair[1]) - 1):
								add_bolt.rpc(n_slate.position, snake.pos, n_slate.color)
								slate_score += 100
								n_slate.score = slate_score
								n_slate.show_score.rpc(slate_score)

				if is_area_filled(cell_pos, slate.color, false):
					#snake.trim_tail(snake.get_node('Tails').get_children().size())
					close_area(cell_pos)
				#else:
				snake.trim_tail(score)
		else:
			if !player.is_autopilot:
				player.set_state("PlayerEliminated")


@rpc("any_peer","call_local")
func add_bolt(from, to, color):
	var bolt = preload("res://bolt.tscn").instantiate()
	if from.x > to.x:
		bolt.reverse = true
		bolt.p1 = to
		bolt.p2 = from
	else:
		bolt.p1 = from
		bolt.p2 = to
	bolt.color = color
	bolt.alpha = 0
	add_child(bolt)
	
func close_area(cell_pos):
	var field_pos = field_map.project(cell_pos)
	var area = field_map.get_area(field_pos)
	var cells = field_map.get_area_cells(area)
	if cells.size() == 0:
		return false
	for cell in cells:
		var u_pos = field_map.unproject(Vector2(cell[0],cell[1]))
		for slate in $Objects.get_children():
			if slate is Slate and slate.x == u_pos.x and slate.y == u_pos.y:
				$BlockRaiser.slate_queue.push_back(slate)

func is_area_filled(cell_pos, color, with_color : bool):
	var field_pos = field_map.project(cell_pos)
	var area = field_map.get_area(field_pos)
	var cells = field_map.get_area_cells(area)
	if cells.size() == 0:
		return false
	var filled = 0
	var same_color = 0
	for cell in cells:
		var pos = field_map.unproject(Vector2(cell[0],cell[1]))
		var key = get_cell_key(pos)
		if !empty_map[key]:
			filled += 1
		if color_map.has(key) and color_map[key] == color:
			same_color += 1
	if with_color and same_color == cells.size():
		return true
	if filled == cells.size():
		return true
	return false

func get_cell_key(cell_pos):
	return str(cell_pos.x)+'_'+str(cell_pos.y + 1)

func del_player(id: int):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()


func _on_players_spawner_spawned(node):
	node.change_state.connect(on_player_state_change)
	node.spawned(node)


func _on_screen_faded(anim_name):
	$StateMachine.transit("FieldGame")

func next_level():
	set_state.rpc("FieldNextLevel")
		

@rpc("any_peer","call_local")
func change_level_id(new_id):
	if new_id > max_level:
		new_id = 1
	if new_id < 1:
		new_id = max_level
	level_id = new_id

@rpc("any_peer", "call_local")
func set_state(new_state):
	$StateMachine.transit(new_state)

func _on_state_change(state, current_state):
	print('Field State: ', current_state,'->',state)
