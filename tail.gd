extends StaticBody3D
class_name Tail

@export var index := 0
@export var next_pos := Vector3(0,0,0)

func _ready():
	$MeshInstance3D.set_instance_shader_parameter('index', float(index))
