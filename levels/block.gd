@tool
extends StaticBody3D
class_name Block

@export var x := 0:
	set(new_x):
		x = new_x
		if Engine.is_editor_hint():
			rebuild.call_deferred()
		
@export var y := 0:
	set(new_y):
		y = new_y
		if Engine.is_editor_hint():
			rebuild.call_deferred()
		
@export var width := 1:
	set(new_width):
		width = new_width
		if Engine.is_editor_hint():
			rebuild.call_deferred()
		
@export var height := 1:
	set(new_height):
		height = new_height
		if Engine.is_editor_hint():
			rebuild.call_deferred()

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		pass

func rebuild():
	for child in get_children():
		child.queue_free()
	var mesh = MeshInstance3D.new()
	mesh.mesh = BoxMesh.new()
	mesh.mesh.set_size(Vector3(round(width)*2 - .14, round(height)*2 - .14, 1.))
	mesh.mesh.set_material(preload("res://levels/block_material.tres"))
	mesh.set_instance_shader_parameter("dimensions", Vector2(width, height))
	mesh.set_instance_shader_parameter("pos", Vector2(x, y))
	position = Vector3(x * 2 + 1.07, y * 2 + .93, .02 + randf_range(0,.2))

	add_child(mesh)
	
	var collision = CollisionShape3D.new()
	
	var shape = BoxShape3D.new()
	shape.set_size(mesh.mesh.get_size())
	
	collision.set_shape(shape)
	add_child(collision)

func _ready():
	if Engine.is_editor_hint():
		return
	rebuild()
	set_process(true)
	
func _process(delta):
	position.z += delta
	if position.z >= .5:
		position.z = .5
		set_process(false)
