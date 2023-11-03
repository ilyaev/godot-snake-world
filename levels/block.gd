@tool
extends StaticBody3D
class_name Block

@export var x := 0:
	set(new_x):
		x = new_x
		rebuild()
		
@export var y := 0:
	set(new_y):
		y = new_y
		rebuild()
		
@export var width := 1:
	set(new_width):
		width = new_width
		rebuild()
		
@export var height := 1:
	set(new_height):
		height = new_height
		rebuild()

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		print('NEW POS:', position)

func rebuild():
	for child in get_children():
		child.queue_free()
		
	var mesh = MeshInstance3D.new()
	mesh.mesh = BoxMesh.new()
	mesh.mesh.set_size(Vector3(round(width)*2 - .11, round(height)*2 - .11, 1.))
	mesh.mesh.set_material(preload("res://levels/block_material.tres"))
	mesh.set_instance_shader_parameter("dimensions", Vector2(width, height))
	position = Vector3(x * 2 + 1.1, y * 2 + .9, .001)

	add_child(mesh)
	
	var collision = CollisionShape3D.new()
	
	var shape = BoxShape3D.new()
	shape.set_size(mesh.mesh.get_size())
	
	collision.set_shape(shape)
	add_child(collision)
	
	pass
