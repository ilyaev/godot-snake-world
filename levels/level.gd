@tool
extends MeshInstance3D
class_name Level

var dimensions := Vector2(20, 20)
var empty_map : Dictionary = {}
var block_map : Dictionary = {}
var field_map = FieldMap.new()

var block_queue : Array[Slate] = []


@export var noise_texture : Texture:
	set(new_noise_texture):
		noise_texture = new_noise_texture
		var mesh2 = QuadMesh.new()
		mesh2.set_size(noise_texture.get_size() * 2.)
		mesh2.set_material(preload("res://board_material.tres"))
		dimensions = noise_texture.get_size()
		set_mesh(mesh2)
		get_active_material(0).set_shader_parameter("level", noise_texture)
		set_instance_shader_parameter("dimensions", dimensions)
		
		build_walls()

func get_add_node(node_name):
	var flag = false
	for child in get_children():
		if child.name == node_name:
			flag = true
			for wall in child.get_children():
				wall.queue_free()			
	if !flag:
		var walls = Node3D.new()
		walls.set_name(node_name)
		add_child(walls)
	return get_node(node_name)


func build_walls():
	get_add_node('WALLS')
	
	add_wall('Bottom', Vector3(dimensions.x * 2 + 2, 1, 1), Vector3(0, dimensions.y * -1 - .5, .5))
	add_wall('Top', Vector3(dimensions.x * 2 + 2, 1, 1), Vector3(0, dimensions.y + .5, .5))
	
	add_wall('Left', Vector3(dimensions.y * 2 + 2, 1, 1), Vector3(dimensions.x + .5, 0, .5))
	add_wall('Right', Vector3(dimensions.y * 2 + 2, 1, 1), Vector3(dimensions.x * -1 - .5, 0, .5))

func add_wall(title, size, pos):
	var new_mesh = MeshInstance3D.new()
	new_mesh.mesh = BoxMesh.new()
	new_mesh.mesh.set_size(size)
	new_mesh.mesh.set_material(preload("res://levels/wall_material.tres"))
	
	var body = StaticBody3D.new()
	body.add_child(new_mesh)
	body.position = pos
	
	var collision = CollisionShape3D.new()
	
	var shape = BoxShape3D.new()
	shape.set_size(size)
	
	collision.set_shape(shape)
	body.add_child(collision)
	
	if title == 'Left' or title == 'Right':
		body.basis = Basis().rotated(Vector3.FORWARD, PI/2)
	
	get_node('WALLS').add_child(body)


func build_maps():
	var level_image = noise_texture.get_image()
	for x in range(dimensions.x/2 * -1 + 1, dimensions.x/2):
		for y in range(dimensions.y/2 * -1 + 1, dimensions.y/2):
			var is_empty = false
			var pixel = level_image.get_pixelv(Vector2(x, y * -1) + dimensions/2).r
			if pixel > .1:
				is_empty = true
			empty_map[str(x) + '_' + str(y)] = is_empty

	field_map.init(level_image)
	
	for block in get_children():
		if block is Block:
			var start_x = block.x - floor(block.width/2)
			var start_y = block.y - floor(block.height/2)
			for x in range(start_x, start_x + block.width):
				for y in range(start_y, start_y + block.height):
					block_map[str(x) + '_' + str(y)] = true

func add_block(x,y):
	var block = preload("res://levels/block.tscn").instantiate()
	block.width = 1
	block.height = 1
	block.x = x
	block.y = y
	block_map[str(x) + '_' + str(y)] = true
	return block
	#add_child(block)

func find_empty_cell_center():
	var pos = find_empty_cell()
	return pos * 2 + Vector3(1,1,0)

func find_empty_cell():
	var pos = Vector3(0,0,0)
	for i in range(0, 20):
		pos = Vector3(randi_range(0, dimensions.x), randi_range(0, dimensions.y), 0) - Vector3(dimensions.x/2, dimensions.y/2,0)
		var key = str(pos.x) + '_' + str(pos.y)
		if abs(pos.x) >= (dimensions.x/2 - 2) or abs(pos.y) >= (dimensions.y/2 - 2):
			continue
		if !empty_map[str(pos.x) + '_' + str(pos.y+1)] and !block_map.has(key):
			break
	return pos
