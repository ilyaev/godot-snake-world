@tool
extends MeshInstance3D
class_name Slate

@export var x := 0:
	set(new_x):
		x = new_x
		position = Vector3(1.07 + x * 2, .93 + y * 2, 0.001)

@export var y := 0:
	set(new_y):
		y = new_y
		position = Vector3(1.07 + x * 2, .93 + y * 2, 0.001)

@export var color: Color:
	set(new_color):
		color = new_color
		set_instance_shader_parameter('color', color)

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector3(1.07 + x * 2, .93 + y * 2, 0.001)
	set_instance_shader_parameter('color', color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
